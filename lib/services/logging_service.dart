import 'package:flutter/foundation.dart';

class LoggingService {
  static void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('ERROR: $message');
      if (error != null) {
        print('  Error: $error');
      }
      if (stackTrace != null) {
        print('  StackTrace: $stackTrace');
      }
    }
    // In a production app, you would send this to a remote logging service
    // like Firebase Crashlytics or Sentry.
  }

  static void logInfo(String message) {
    if (kDebugMode) {
      print('INFO: $message');
    }
  }
}
