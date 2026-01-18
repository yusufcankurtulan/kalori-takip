import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../widgets/app_scaffold.dart';

class DietResultScreen extends StatefulWidget {
  final String program;
  final int age;
  final int weight;
  final int height;
  final String activity;
  final String meals;
  final List<String> restrictions;
  final String prompt;

  DietResultScreen({
    required this.program,
    required this.age,
    required this.weight,
    required this.height,
    required this.activity,
    required this.meals,
    required this.restrictions,
    required this.prompt,
  });

  @override
  _DietResultScreenState createState() => _DietResultScreenState();
}

class _DietResultScreenState extends State<DietResultScreen> {
  String? _result;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchResult();
  }

  Future<void> _fetchResult() async {
    setState(() { _loading = true; _error = null; });
    try {
      // AI servisinden öneri al
      final ai = await AIService.generateProgram({
        'program': widget.program,
        'age': widget.age,
        'weight': widget.weight,
        'height': widget.height,
        'activity': widget.activity,
        'meals': widget.meals,
        'restrictions': widget.restrictions,
        'prompt': widget.prompt,
      });
      setState(() {
        _result = ai;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = "AI'dan yanıt alınamadı: $e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Sonuç",
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Text(_result ?? "Sonuç yok", style: TextStyle(fontSize: 16)),
                ),
    );
  }
}
