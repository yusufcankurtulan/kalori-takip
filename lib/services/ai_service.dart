import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AIService {
  // Placeholder endpoint - replace with your Cloud Function or API
  static const _imageCalorieEndpoint = 'https://YOUR_CLOUD_FUNCTION_URL/estimate-calories';
  static const _planEndpoint = 'https://YOUR_CLOUD_FUNCTION_URL/generate-plan';

  // Upload image and request calorie estimation
  static Future<String?> estimateCalories(File imageFile) async {
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
      throw Exception('API hata: ${resp.statusCode}');
    }
  }

  // Generate personalized program via text-based AI (OpenAI/other)
  static Future<String?> generateProgram(Map<String, dynamic> profile) async {
    final uri = Uri.parse(_planEndpoint);
    final resp = await http.post(uri, body: json.encode(profile), headers: {
      'Content-Type': 'application/json'
    });
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      return data['plan'];
    }
    return null;
  }
}
