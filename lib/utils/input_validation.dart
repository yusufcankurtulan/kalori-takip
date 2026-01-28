/// Input validation utilities for the application.
///
/// Provides comprehensive validation for:
/// - Email addresses
/// - Passwords (with strength checking)
/// - Names
/// - Numeric values (age, weight, height)
/// - General string sanitization
class InputValidation {
  // Regular expressions for validation
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  static final RegExp _nameRegex = RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s\-]{2,50}$');

  static final RegExp _numericRegex = RegExp(r'^\d+(\.\d+)?$');

  static final RegExp _specialCharRegex = RegExp(r'[<>{}\[\]\/\\|=;,\'\"&]');

  // Password validation errors
  static const String _passwordTooShort = 'Şifre en az 8 karakter olmalıdır';
  static const String _passwordNoUppercase = 'Şifre en az bir büyük harf içermelidir';
  static const String _passwordNoLowercase = 'Şifre en az bir küçük harf içermelidir';
  static const String _passwordNoNumber = 'Şifre en az bir rakam içermelidir';
  static const String _passwordNoSpecial = 'Şifre en az bir özel karakter (@\$!%*?&) içermelidir';

  /// Validates and returns a list of password validation errors.
  /// Returns empty list if password is valid.
  static List<String> validatePassword(String password) {
    final List<String> errors = [];

    if (password.isEmpty) {
      return ['Şifre boş olamaz'];
    }

    if (password.length < 8) {
      errors.add(_passwordTooShort);
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      errors.add(_passwordNoUppercase);
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      errors.add(_passwordNoLowercase);
    }

    if (!password.contains(RegExp(r'\d'))) {
      errors.add(_passwordNoNumber);
    }

    if (!password.contains(RegExp(r'[@$!%*?&]'))) {
      errors.add(_passwordNoSpecial);
    }

    return errors;
  }

  /// Validates email format.
  /// Returns null if valid, error message if invalid.
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'E-posta adresi boş olamaz';
    }

    if (!_emailRegex.hasMatch(email)) {
      return 'Geçerli bir e-posta adresi giriniz';
    }

    final parts = email.split('@');
    if (parts.length != 2) {
      return 'Geçerli bir e-posta adresi giriniz';
    }

    final domain = parts[1];
    if (domain.length < 2 || !domain.contains('.')) {
      return 'Geçerli bir e-posta adresi giriniz';
    }

    return null;
  }

  /// Validates name format (first name or last name).
  static String? validateName(String name, String fieldName) {
    if (name.isEmpty) {
      return '$fieldName boş olamaz';
    }

    if (name.length < 2) {
      return '$fieldName en az 2 karakter olmalıdır';
    }

    if (name.length > 50) {
      return '$fieldName en fazla 50 karakter olabilir';
    }

    if (!_nameRegex.hasMatch(name)) {
      return '$fieldName sadece harf içerebilir';
    }

    return null;
  }

  /// Validates age (must be between 1 and 120)
  static String? validateAge(int age) {
    if (age < 1) {
      return 'Yaş 1\'den küçük olamaz';
    }
    if (age > 120) {
      return 'Yaş 120\'den büyük olamaz';
    }
    return null;
  }

  /// Validates height in centimeters (must be between 30 and 300)
  static String? validateHeight(double height) {
    if (height < 30) {
      return 'Boy 30cm\'den küçük olamaz';
    }
    if (height > 300) {
      return 'Boy 300cm\'den büyük olamaz';
    }
    return null;
  }

  /// Validates weight in kilograms (must be between 1 and 500)
  static String? validateWeight(double weight) {
    if (weight < 1) {
      return 'Kilo 1kg\'dan küçük olamaz';
    }
    if (weight > 500) {
      return 'Kilo 500kg\'dan büyük olamaz';
    }
    return null;
  }

  /// Calculates password strength (0-100)
  static int calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int score = 0;

    // Length points (max 25)
    if (password.length >= 8) score += 10;
    if (password.length >= 12) score += 10;
    if (password.length >= 16) score += 5;

    // Character variety points (max 40)
    if (password.contains(RegExp(r'[A-Z]'))) score += 10;
    if (password.contains(RegExp(r'[a-z]'))) score += 10;
    if (password.contains(RegExp(r'\d'))) score += 10;
    if (password.contains(RegExp(r'[@$!%*?&]'))) score += 10;

    // Bonus points (max 35)
    if (password.contains(RegExp(r'[^A-Za-z\d@$!%*?&]'))) score += 10; // Special chars
    if (password.length >= 20) score += 10; // Long password
    if (!password.contains(RegExp(r'^[a-zA-Z]+$'))) score += 5; // Mixed types
    if (!password.contains(RegExp(r'^[\d]+$'))) score += 5; // Not just numbers
    if (!password.contains(RegExp(r'^(.)\1{2,}'))) score += 5; // No 3+ repeated chars

    return score.clamp(0, 100);
  }

  /// Returns password strength label
  static String getPasswordStrengthLabel(int strength) {
    if (strength < 30) return 'Zayıf';
    if (strength < 50) return 'Orta';
    if (strength < 70) return 'İyi';
    if (strength < 90) return 'Güçlü';
    return 'Çok Güçlü';
  }

  /// Sanitizes input to prevent XSS attacks
  static String sanitizeInput(String input) {
    String sanitized = input.trim();

    // Remove potential XSS patterns
    sanitized = sanitized.replaceAll('<script', '');
    sanitized = sanitized.replaceAll('</script>', '');
    sanitized = sanitized.replaceAll('javascript:', '');
    sanitized = sanitized.replaceAll('onload=', '');
    sanitized = sanitized.replaceAll('onerror=', '');
    sanitized = sanitized.replaceAll('<iframe', '');
    sanitized = sanitized.replaceAll('</iframe>', '');
    sanitized = sanitized.replaceAll('<?php', '');
    sanitized = sanitized.replaceAll('<%', '');

    // Encode HTML entities
    sanitized = sanitized
        .replaceAll('&', '&amp;')
        .replaceAll('<', '<')
        .replaceAll('>', '>')
        .replaceAll('"', '"')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;')
        .replaceAll('[', '&#x5B;')
        .replaceAll(']', '&#x5D;')
        .replaceAll('{', '&#x7B;')
        .replaceAll('}', '&#x7D;');

    return sanitized;
  }

  /// Checks if string contains special characters that might indicate injection
  static bool containsSuspiciousChars(String input) {
    return _specialCharRegex.hasMatch(input);
  }

  /// Validates confirm password matches original
  static String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Şifre onayı boş olamaz';
    }
    if (password != confirmPassword) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }

  /// Validates goal selection
  static String? validateGoal(String goal) {
    const validGoals = ['lose', 'gain', 'maintain'];
    if (goal.isEmpty) {
      return 'Lütfen bir hedef seçiniz';
    }
    if (!validGoals.contains(goal)) {
      return 'Geçersiz hedef seçimi';
    }
    return null;
  }

  /// Validates activity level selection
  static String? validateActivityLevel(String level) {
    const validLevels = ['sedentary', 'active'];
    if (level.isEmpty) {
      return 'Lütfen aktivite seviyesi seçiniz';
    }
    if (!validLevels.contains(level)) {
      return 'Geçersiz aktivite seviyesi';
    }
    return null;
  }
}

