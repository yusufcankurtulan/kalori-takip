import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for storing sensitive user data.
///
/// This service replaces SharedPreferences for sensitive data like:
/// - Authentication tokens
/// - User credentials
/// - Personal identification information
class SecureStorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Storage keys - all prefixed for organization
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _emailKey = 'user_email';
  static const String _sessionExpiryKey = 'session_expiry';
  static const String _fcmTokenKey = 'fcm_token';

  /// Store authentication token securely
  static Future<void> setAuthToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Retrieve authentication token
  static Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Delete authentication token
  static Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  /// Store refresh token for token refresh flow
  static Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  /// Retrieve refresh token
  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  /// Store user ID
  static Future<void> setUserId(String userId) async {
    await _secureStorage.write(key: _userIdKey, value: userId);
  }

  /// Retrieve user ID
  static Future<String?> getUserId() async {
    return await _secureStorage.read(key: _userIdKey);
  }

  /// Store user email
  static Future<void> setUserEmail(String email) async {
    await _secureStorage.write(key: _emailKey, value: email);
  }

  /// Retrieve user email
  static Future<String?> getUserEmail() async {
    return await _secureStorage.read(key: _emailKey);
  }

  /// Store session expiry timestamp
  static Future<void> setSessionExpiry(DateTime expiry) async {
    await _secureStorage.write(key: _sessionExpiryKey, value: expiry.toIso8601String());
  }

  /// Check if session is expired
  static Future<bool> isSessionExpired() async {
    final expiryStr = await _secureStorage.read(key: _sessionExpiryKey);
    if (expiryStr == null) return true;
    try {
      final expiry = DateTime.parse(expiryStr);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return true; // Treat parse errors as expired
    }
  }

  /// Store FCM token for push notifications
  static Future<void> setFcmToken(String token) async {
    await _secureStorage.write(key: _fcmTokenKey, value: token);
  }

  /// Retrieve FCM token
  static Future<String?> getFcmToken() async {
    return await _secureStorage.read(key: _fcmTokenKey);
  }

  /// Clear all stored sensitive data (for logout)
  static Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
  }

  /// Check if biometric authentication is available
  static Future<bool> isBiometricAvailable() async {
    // Note: This requires additional package: local_auth
    // For now, return false as placeholder
    return false;
  }

  /// Authenticate using biometric (placeholder for future implementation)
  static Future<bool> authenticateWithBiometrics() async {
    // Note: This requires additional package: local_auth
    // For now, return false as placeholder
    return false;
  }
}

