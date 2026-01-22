import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/user_profile.dart';
import 'logging_service.dart';

class UserService {
    // Program sorularının cevaplarını Firestore'a kaydet
    static Future<void> saveProgramAnswers(String uid, String programKey, Map<String, dynamic> answers) async {
      try {
        await fs.FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('programAnswers')
            .doc(programKey)
            .set(answers, fs.SetOptions(merge: true));
      } catch (e, s) {
        LoggingService.logError('Failed to save program answers', e, s);
      }
    }
  // SharedPreferences erişimi için public yardımcı fonksiyon
  static Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }
  static const _profilePrefix = 'profile_';
  static const _dirtyProfilePrefix = 'dirty_profile_';


  // Returns true if the user's profile is already completed.
  static Future<bool> isProfileComplete(String uid) async {
    final profile = await getProfile(uid);
    // A profile is considered complete if it exists and the goal is not empty.
    // This is a simple check, could be made more robust.
    return profile != null && profile.goal.isNotEmpty;
  }

  // Save profile data. Implements a write-through cache.
  static Future<void> saveProfile(String uid, UserProfile profile) async {
    // Always update the local cache first.
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(profile.toJson());
      await prefs.setString('$_profilePrefix$uid', profileJson);
    } catch (e, s) {
      LoggingService.logError('Failed to save profile to SharedPreferences', e, s);
    }

    // Try to write to Firestore.
    try {
      await fs.FirebaseFirestore.instance.collection('users').doc(uid).set(profile.toJson(), fs.SetOptions(merge: true));
      // If successful, remove the 'dirty' flag.
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_dirtyProfilePrefix$uid');
    } catch (e, s) {
      LoggingService.logError('Failed to save profile to Firestore', e, s);
      // If Firestore write fails, mark the profile as 'dirty'.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$_dirtyProfilePrefix$uid', true);
    }
  }

  // Read profile data. Implements a cache-aside strategy.
  static Future<UserProfile?> getProfile(String uid) async {
    UserProfile? profile;
    final prefs = await SharedPreferences.getInstance();

    // Try to get data from Firestore if online.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final doc = await fs.FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          data['id'] = doc.id;
          profile = UserProfile.fromJson(data);
          // Update cache
          final profileJson = jsonEncode(profile.toJson());
          await prefs.setString('$_profilePrefix$uid', profileJson);
        }
      } catch (e, s) {
        LoggingService.logError('Failed to get profile from Firestore', e, s);
      }
    }

    // If we don't have a profile from Firestore, try the cache.
    if (profile == null) {
      try {
        final profileJson = prefs.getString('$_profilePrefix$uid');
        if (profileJson != null) {
          profile = UserProfile.fromJson(jsonDecode(profileJson));
        }
      } catch (e, s) {
        LoggingService.logError('Failed to get profile from SharedPreferences', e, s);
      }
    }
    
    // If there is a dirty profile, try to sync it.
    if (prefs.getBool('$_dirtyProfilePrefix$uid') == true && profile != null) {
      await saveProfile(uid, profile);
    }

    return profile;
  }

  // Save a chosen program for the user (Firestore first, SharedPreferences fallback)
  static Future<void> saveProgram(String uid, String program) async {
    bool firestoreOk = false;
    try {
      await fs.FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'program': program}, fs.SetOptions(merge: true))
          .timeout(Duration(seconds: 2));
      firestoreOk = true;
    } catch (e, s) {
      LoggingService.logError('Failed to save program to Firestore', e, s);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_program_$uid', program);
    } catch (e, s) {
      LoggingService.logError('Failed to save program to SharedPreferences', e, s);
    }
    if (!firestoreOk) {
      LoggingService.logInfo('Firestore save failed, saved locally.');
    }
  }

  static Future<String?> getProgram(String uid) async {
    try {
      final doc = await fs.FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['program'] != null) return data['program'] as String;
      }
    } catch (e, s) {
      LoggingService.logError('Failed to get program from Firestore', e, s);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_program_$uid');
    } catch (e, s) {
      LoggingService.logError('Failed to get program from SharedPreferences', e, s);
    }
    return null;
  }

  // Save selected diet program
  static Future<void> saveSelectedDietProgram(
    String uid,
    String programKey,
    Map<String, dynamic> dietProgram,
  ) async {
    try {
      await fs.FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
            'program': programKey,
            'selectedDietProgram': dietProgram,
            'dietProgramUpdatedAt': fs.FieldValue.serverTimestamp(),
          }, fs.SetOptions(merge: true));
    } catch (e, s) {
      LoggingService.logError('Failed to save selected diet program', e, s);
      rethrow;
    }
  }

  // Get selected diet program
  static Future<Map<String, dynamic>?> getSelectedDietProgram(String uid) async {
    try {
      final doc = await fs.FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['selectedDietProgram'] != null) {
          return Map<String, dynamic>.from(data['selectedDietProgram'] as Map);
        }
      }
    } catch (e, s) {
      LoggingService.logError('Failed to get selected diet program', e, s);
    }
    return null;
  }
}