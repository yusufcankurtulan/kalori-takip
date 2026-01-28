import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'logging_service.dart';

/// Authentication security service that provides additional security features
/// beyond the basic Firebase Auth.
///
/// Features:
/// - Failed login attempt tracking
/// - Account lockout after multiple failures
/// - Rate limiting
/// - Suspicious activity detection
class AuthSecurityService {
  // Configuration constants
  static const int _maxFailedAttempts = 5;
  static const Duration _lockoutDuration = Duration(minutes: 15);
  static const Duration _failedAttemptWindow = Duration(minutes: 30);
  static const int _maxAttemptsInWindow = 10;

  // In-memory storage for tracking (in production, use Firestore or Redis)
  static final Map<String, _FailedAttemptInfo> _failedAttempts = {};
  static final Map<String, _LockoutInfo> _lockouts = {};
  static final Map<String, List<DateTime>> _loginHistory = {};

  /// Records a failed login attempt
  static Future<void> recordFailedAttempt(String email) async {
    final normalizedEmail = email.toLowerCase().trim();
    final now = DateTime.now();

    final info = _failedAttempts[normalizedEmail] ?? _FailedAttemptInfo();
    info.attempts.add(now);
    info.attempts.removeWhere((t) => now.difference(t) > _failedAttemptWindow);
    info.count++;
    _failedAttempts[normalizedEmail] = info;

    LoggingService.logInfo('Failed login attempt for $normalizedEmail. Total: ${info.count}');

    // Check if we should lock out the account
    if (info.count >= _maxFailedAttempts) {
      await _lockAccount(normalizedEmail);
    }
  }

  /// Records a successful login - clears failed attempts
  static void recordSuccessfulLogin(String email) {
    final normalizedEmail = email.toLowerCase().trim();
    _failedAttempts.remove(normalizedEmail);
    _lockouts.remove(normalizedEmail);

    // Update login history
    final now = DateTime.now();
    final history = _loginHistory[normalizedEmail] ?? [];
    history.add(now);
    history.removeWhere((t) => now.difference(t) > Duration(hours: 24));
    _loginHistory[normalizedEmail] = history;

    LoggingService.logInfo('Successful login for $normalizedEmail');
  }

  /// Checks if an account is locked out
  static Future<bool> isAccountLockedOut(String email) async {
    final normalizedEmail = email.toLowerCase().trim();
    final lockout = _lockouts[normalizedEmail];

    if (lockout == null) return false;

    if (DateTime.now().isAfter(lockout.unlockTime)) {
      // Lockout period expired, remove it
      _lockouts.remove(normalizedEmail);
      return false;
    }

    return true;
  }

  /// Gets remaining lockout time in minutes
  static Future<int> getRemainingLockoutMinutes(String email) async {
    final normalizedEmail = email.toLowerCase().trim();
    final lockout = _lockouts[normalizedEmail];

    if (lockout == null) return 0;

    final remaining = lockout.unlockTime.difference(DateTime.now());
    return remaining.inMinutes.clamp(0, 15);
  }

  /// Checks if rate limit is exceeded
  static bool isRateLimitExceeded(String ipAddress) {
    final now = DateTime.now();
    final history = _loginHistory[ipAddress] ?? [];

    // Clean old entries
    history.removeWhere((t) => now.difference(t) > _failedAttemptWindow);

    return history.length >= _maxAttemptsInWindow;
  }

  /// Gets failed attempt count for an email
  static int getFailedAttemptCount(String email) {
    final normalizedEmail = email.toLowerCase().trim();
    final info = _failedAttempts[normalizedEmail];
    return info?.count ?? 0;
  }

  /// Locks an account after too many failed attempts
  static Future<void> _lockAccount(String email) async {
    final unlockTime = DateTime.now().add(_lockoutDuration);
    _lockouts[email] = _LockoutInfo(unlockTime: unlockTime);
    LoggingService.logInfo('Account locked for $email until $unlockTime');
  }

  /// Manually unlocks an account (for admin use)
  static void unlockAccount(String email) {
    final normalizedEmail = email.toLowerCase().trim();
    _lockouts.remove(normalizedEmail);
    _failedAttempts.remove(normalizedEmail);
    LoggingService.logInfo('Account manually unlocked for $normalizedEmail');
  }

  /// Checks if email format is valid (basic check before Firebase)
  static bool isEmailFormatValid(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Handles Firebase Auth exceptions and returns user-friendly messages
  static String handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Bu e-posta adresiyle kayıtlı bir hesap bulunamadı';
      case 'wrong-password':
        return 'Hatalı şifre girdiniz';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi formatı';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakılmış';
      case 'too-many-requests':
        return 'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin';
      case 'network-request-failed':
        return 'Ağ hatası. İnternet bağlantınızı kontrol edin';
      case 'invalid-credential':
        return 'Kimlik doğrulama başarısız';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanımda';
      case 'weak-password':
        return 'Şifre çok zayıf. Daha güçlü bir şifre seçin';
      case 'operation-not-allowed':
        return 'Bu işlem şu anda devre dışı';
      case 'expired-action-code':
        return 'Bu işlem için gereken kodun süresi dolmuş';
      case 'invalid-action-code':
        return 'Geçersiz veya kullanılmış işlem kodu';
      default:
        LoggingService.logError('Unhandled auth error code: ${e.code}', e.message);
        return 'Bir hata oluştu. Lütfen tekrar deneyin';
    }
  }

  /// Checks for suspicious login patterns
  static Future<bool> detectSuspiciousActivity(String email, String ipAddress) async {
    // Check if this is a new device/location
    // This would require storing historical login data
    // For now, we'll do basic checks

    // Check for rapid successive attempts
    if (isRateLimitExceeded(ipAddress)) {
      LoggingService.logError('Rate limit exceeded for IP: $ipAddress');
      return true;
    }

    // Check for account lockout
    if (await isAccountLockedOut(email)) {
      return true;
    }

    return false;
  }

  /// Gets security status for an email
  static Future<Map<String, dynamic>> getSecurityStatus(String email) async {
    final normalizedEmail = email.toLowerCase().trim();
    final failedCount = getFailedAttemptCount(email);
    final isLocked = await isAccountLockedOut(email);
    final remainingLockout = await getRemainingLockoutMinutes(email);

    return {
      'email': normalizedEmail,
      'failedAttempts': failedCount,
      'isLockedOut': isLocked,
      'remainingLockoutMinutes': remainingLockout,
      'maxFailedAttempts': _maxFailedAttempts,
      'lockoutDurationMinutes': _lockoutDuration.inMinutes,
    };
  }

  /// Cleanup old entries (should be called periodically)
  static void cleanupOldEntries() {
    final now = DateTime.now();

    // Clean failed attempts
    _failedAttempts.forEach((email, info) {
      info.attempts.removeWhere((t) => now.difference(t) > _failedAttemptWindow);
      if (info.attempts.isEmpty) {
        _failedAttempts.remove(email);
      }
    });

    // Clean lockouts
    _lockouts.forEach((email, info) {
      if (now.isAfter(info.unlockTime)) {
        _lockouts.remove(email);
      }
    });

    // Clean login history
    _loginHistory.forEach((key, history) {
      history.removeWhere((t) => now.difference(t) > Duration(hours: 24));
      if (history.isEmpty) {
        _loginHistory.remove(key);
      }
    });
  }
}

/// Internal class to track failed attempts
class _FailedAttemptInfo {
  int count = 0;
  List<DateTime> attempts = [];
}

/// Internal class to track lockout information
class _LockoutInfo {
  final DateTime unlockTime;

  _LockoutInfo({required this.unlockTime});
}

