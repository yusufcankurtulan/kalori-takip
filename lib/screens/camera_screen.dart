import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ai_service.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  String _result = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked == null) return;
    setState(() {
      _image = File(picked.path);
      _result = 'Tahmin hazırlanıyor...';
    });

    try {
      final res = await AIService.estimateCalories(_image!);
      setState(() {
        _result = res ?? 'Tahmin yapılamadı';
      });
    } catch (e) {
      setState(() {
        _result = 'Hata: ' + e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kamera - Kalori Tahmini')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: _pickImage, child: Text('Fotoğraf Çek')),
            SizedBox(height: 12),
            if (_image != null) Image.file(_image!, height: 200),
            SizedBox(height: 12),
            Text(_result),
          ],
        ),
      ),
    );
  }
}

