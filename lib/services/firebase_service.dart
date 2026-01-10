import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirebaseService {
  static Future<void> init() async {
    try {
      // Prefer explicit options (works cross-platform when generated)
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      print('Firebase initialized successfully');
    } catch (e) {
      // Fallback to default initialization; log the error but don't crash the app.
      print('Firebase.initializeApp error: $e');
      try {
        await Firebase.initializeApp();
      } catch (err) {
        print('Firebase fallback initializeApp failed: $err');
        // If initialization still fails, continue without Firebase (useful for local dev)
      }
    }
  }
}
