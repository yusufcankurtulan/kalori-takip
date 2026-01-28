import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'logging_service.dart';

class AIService {
  // For iOS Simulator use localhost, for Android Emulator use 10.0.2.2
  // IMPORTANT: Always use HTTPS in production
  // For local development, update the BASE_URL to your local server's HTTPS port
  // or use the IP address with HTTPS if configured
  static const String _baseURL = 'http://localhost:3000';
  static const String _imageCalorieEndpoint = '$_baseURL/estimate-calories';
  static const String _planEndpoint = '$_baseURL/generate-plan';
  static const String _dietProgramsEndpoint = '$_baseURL/generate-diet-programs';

  // Upload image and request calorie estimation
  static Future<String?> estimateCalories(File imageFile) async {
    try {
      final uri = Uri.parse(_imageCalorieEndpoint);
      
      // Validate file before upload
      if (!imageFile.existsSync()) {
        LoggingService.logError('Image file does not exist', imageFile.path);
        return null;
      }
      
      // Check file size (max 10MB)
      final fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        LoggingService.logError('Image file too large', 'Size: $fileSize bytes');
        return null;
      }
      
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      
      // Add security headers
      request.headers['Accept'] = 'application/json';
      
      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);
      
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        // Expected response: { "calories": 450, "items": [ ... ] }
        return 'Tahmini kalori: ' + (data['calories']?.toString() ?? 'bilinmiyor');
      } else {
        LoggingService.logError('Failed to estimate calories. Status code: ${resp.statusCode}', resp.body);
        return null;
      }
    } catch (e, s) {
      LoggingService.logError('Failed to estimate calories', e, s);
      return null;
    }
  }

  // Generate personalized program via text-based AI (OpenAI/other)
  static Future<String?> generateProgram(Map<String, dynamic> profile) async {
    try {
      final uri = Uri.parse(_planEndpoint);
      
      // Sanitize input to prevent injection attacks
      final sanitizedProfile = _sanitizeProfileData(profile);
      
      final resp = await http.post(uri, body: json.encode(sanitizedProfile), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        return data['plan'];
      } else {
        LoggingService.logError('Failed to generate program. Status code: ${resp.statusCode}', resp.body);
        return null;
      }
    } catch (e, s) {
      LoggingService.logError('Failed to generate program', e, s);
      return null;
    }
  }

  // Generate multiple diet program alternatives
  static Future<Map<String, dynamic>?> generateDietPrograms({
    required String programKey,
    required Map<String, dynamic> answers,
    Map<String, dynamic>? userProfile,
  }) async {
    try {
      final uri = Uri.parse(_dietProgramsEndpoint);
      
      final requestBody = {
        'programKey': _sanitizeString(programKey),
        'answers': _sanitizeMap(answers),
        'userProfile': userProfile != null ? _sanitizeMap(userProfile) : null,
      };
      
      final resp = await http.post(
        uri,
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body) as Map<String, dynamic>;
        return data;
      } else {
        LoggingService.logError('Failed to generate diet programs. Status code: ${resp.statusCode}', resp.body);
        return null;
      }
    } catch (e, s) {
      LoggingService.logError('Failed to generate diet programs', e, s);
      return null;
    }
  }

  /// Sanitize profile data to prevent injection attacks
  static Map<String, dynamic> _sanitizeProfileData(Map<String, dynamic> profile) {
    final sanitized = <String, dynamic>{};
    profile.forEach((key, value) {
      sanitized[_sanitizeString(key)] = _sanitizeValue(value);
    });
    return sanitized;
  }

  /// Sanitize a map recursively
  static Map<String, dynamic> _sanitizeMap(Map<String, dynamic> map) {
    final sanitized = <String, dynamic>{};
    map.forEach((key, value) {
      sanitized[_sanitizeString(key)] = _sanitizeValue(value);
    });
    return sanitized;
  }

  /// Sanitize individual values
  static dynamic _sanitizeValue(dynamic value) {
    if (value is String) {
      return _sanitizeString(value);
    } else if (value is Map<String, dynamic>) {
      return _sanitizeMap(value);
    } else if (value is List) {
      return value.map((item) => _sanitizeValue(item)).toList();
    }
    return value;
  }

  /// Sanitize string to prevent XSS and injection
  static String _sanitizeString(String input) {
    if (input.isEmpty) return input;
    
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll('javascript:', '')
        .replaceAll(RegExp(r'\$ \{[^}]*\}'), '') // Remove template expressions
        .replaceAll(RegExp(r'\{\{[^}]*\}\}'), '') // Remove template syntax
        .trim();
  }
}
