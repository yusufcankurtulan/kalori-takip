import 'package:flutter/foundation.dart';

class LoggingService {
  // Sensitive field names that should be masked in logs
  static const List<String> _sensitiveFields = [
    'password',
    'passwd',
    'secret',
    'token',
    'authToken',
    'refreshToken',
    'apiKey',
    'apikey',
    'creditCard',
    'cardNumber',
    'cvv',
    'ssn',
    'socialSecurity',
    'privateKey',
    'accessToken',
  ];

  static void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      // Sanitize the message for debug mode
      final sanitizedMessage = _sanitizeMessage(message);
      final sanitizedError = error != null ? _sanitizeValue(error) : null;
      
      print('ERROR: $sanitizedMessage');
      if (sanitizedError != null) {
        print('  Error: $sanitizedError');
      }
      if (stackTrace != null) {
        print('  StackTrace: $stackTrace');
      }
    }
    
    // In production, you would send this to a remote logging service
    // like Firebase Crashlytics or Sentry.
    // For production, always sanitize before sending
    if (!kDebugMode) {
      _sendToRemoteLogging(_sanitizeMessage(message), error, stackTrace);
    }
  }

  static void logInfo(String message) {
    if (kDebugMode) {
      final sanitizedMessage = _sanitizeMessage(message);
      print('INFO: $sanitizedMessage');
    }
  }

  /// Logs a warning message (for security-related events)
  static void logSecurityWarning(String event, [dynamic details]) {
    final message = 'SECURITY WARNING: $event';
    if (kDebugMode) {
      print('WARNING: $message');
      if (details != null) {
        print('  Details: ${_sanitizeValue(details)}');
      }
    }
    // Always send security warnings to remote logging in production
    if (!kDebugMode) {
      _sendToRemoteLogging(message, details, null);
    }
  }

  /// Logs authentication events
  static void logAuthEvent(String event, String email, [bool success = true]) {
    final maskedEmail = _maskEmail(email);
    final message = 'AUTH $event: $maskedEmail - ${success ? 'SUCCESS' : 'FAILED'}';
    logInfo(message);
  }

  /// Sanitizes a log message to remove sensitive information
  static String _sanitizeMessage(String message) {
    String sanitized = message;
    
    // Mask email addresses
    sanitized = sanitized.replaceAll(RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'), 
      (match) => _maskEmail(match.group(0)!));
    
    // Mask potential passwords (key-value patterns)
    sanitized = sanitized.replaceAll(RegExp(r'(password|passwd|secret|token)["\']?\s*[:=]\s*["\']?([^\s"\'}]{1,20})["\']?'), 
      r'\1: [REDACTED]');
    
    // Mask credit card numbers (basic pattern)
    sanitized = sanitized.replaceAll(RegExp(r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b'), 
      '[CREDIT_CARD_MASKED]');
    
    return sanitized;
  }

  /// Masks an email address for privacy
  static String _maskEmail(String email) {
    if (!email.contains('@')) return '[INVALID_EMAIL]';
    
    final parts = email.split('@');
    final localPart = parts[0];
    final domain = parts[1];
    
    if (localPart.length <= 2) {
      return '**@${_maskDomain(domain)}';
    }
    
    return '${localPart[0]}${'*' * (localPart.length - 2)}${localPart.last}@${_maskDomain(domain)}';
  }

  /// Masks a domain for privacy
  static String _maskDomain(String domain) {
    final parts = domain.split('.');
    if (parts.length < 2) return domain;
    
    final tld = parts.last;
    final domainParts = parts.sublist(0, parts.length - 1);
    
    return '${domainParts.map((p) => p[0] + '*' * (p.length - 1)).join('.')}.$tld';
  }

  /// Sanitizes a value that might contain sensitive data
  static dynamic _sanitizeValue(dynamic value) {
    if (value == null) return null;
    
    if (value is String) {
      return _sanitizeMessage(value);
    }
    
    if (value is Map<String, dynamic>) {
      final sanitized = <String, dynamic>{};
      value.forEach((key, val) {
        if (_isSensitiveField(key)) {
          sanitized[key] = '[REDACTED]';
        } else {
          sanitized[key] = _sanitizeValue(val);
        }
      });
      return sanitized;
    }
    
    if (value is List) {
      return value.map((item) => _sanitizeValue(item)).toList();
    }
    
    return value;
  }

  /// Checks if a field name is sensitive
  static bool _isSensitiveField(String fieldName) {
    final lowerField = fieldName.toLowerCase();
    return _sensitiveFields.any((field) => lowerField.contains(field));
  }

  /// Placeholder for sending logs to remote service
  /// In production, integrate with Firebase Crashlytics, Sentry, or similar
  static void _sendToRemoteLogging(String message, [dynamic error, StackTrace? stackTrace]) {
    // TODO: Implement remote logging integration
    // Example with Firebase Crashlytics:
    // FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
    
    // For now, just log to console in debug builds
    if (kDebugMode) {
      print('[REMOTE LOG]: $message');
    }
  }
}
