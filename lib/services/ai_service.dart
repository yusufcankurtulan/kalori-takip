import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'logging_service.dart';

class AIService {
  // These endpoints assume you are running the functions server locally.
  // In production, replace with your deployed Cloud Function URLs.
  // Make sure to set the environment variables in functions/index.js:
  // NUTRITIONIX_APP_ID, NUTRITIONIX_APP_KEY, OPENAI_API_KEY
  // For Android emulator, use 10.0.2.2 to reach host machine
  static const _baseURL = 'http://10.0.2.2:3000';
  static const _imageCalorieEndpoint = '$_baseURL/estimate-calories';
  static const _planEndpoint = '$_baseURL/generate-plan';
  static const _dietProgramsEndpoint = '$_baseURL/generate-diet-programs';

  // Upload image and request calorie estimation
  static Future<String?> estimateCalories(File imageFile) async {
    try {
      final uri = Uri.parse(_imageCalorieEndpoint);
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
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
      final resp = await http.post(uri, body: json.encode(profile), headers: {
        'Content-Type': 'application/json'
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
        'programKey': programKey,
        'answers': answers,
        'userProfile': userProfile,
      };
      final resp = await http.post(
        uri,
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json'},
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
}
