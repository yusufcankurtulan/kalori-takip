import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Firestore is optional — if available we'll try to persist profile there.
import 'package:cloud_firestore/cloud_firestore.dart' as fs;

class UserService {
  static const _prefKeyPrefix = 'profile_completed_';

  // Returns true if the user's profile is already completed.
  static Future<bool> isProfileComplete(String uid) async {
    try {
      // Try Firestore first
      final doc = await fs.FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['profileComplete'] == true) return true;
      }
    } catch (e) {
      // Firestore may not be configured / available in dev environment.
    }

    // Fallback to SharedPreferences flag
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('$_prefKeyPrefix$uid') ?? false;
    } catch (e) {
      return false;
    }
  }

  // Save profile data: writes to Firestore (if available) and to shared prefs.
  static Future<void> saveProfile(String uid, Map<String, dynamic> profile) async {
    // Ensure profileComplete flag is set
    final withFlag = Map<String, dynamic>.from(profile);
    withFlag['profileComplete'] = true;

    var wrote = false;
    try {
      await fs.FirebaseFirestore.instance.collection('users').doc(uid).set(withFlag, fs.SetOptions(merge: true));
      wrote = true;
    } catch (e) {
      // ignore firestore error in dev
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$_prefKeyPrefix$uid', true);
      if (!wrote) {
        // store minimal profile for local use
        await prefs.setInt('user_age_$uid', (profile['age'] ?? 0) as int);
        await prefs.setDouble('user_height_$uid', (profile['height'] ?? 0.0) as double);
        await prefs.setDouble('user_weight_$uid', (profile['weight'] ?? 0.0) as double);
        await prefs.setString('user_gender_$uid', (profile['gender'] ?? '') as String);
      }
    } catch (e) {
      // ignore prefs errors
    }
  }
}
