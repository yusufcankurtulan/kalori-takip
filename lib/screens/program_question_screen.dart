import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../services/ai_service.dart';
import 'diet_programs_selection_screen.dart';

class ProgramQuestionScreen extends StatefulWidget {
  final String programKey;
  const ProgramQuestionScreen({Key? key, required this.programKey}) : super(key: key);

  @override
  State<ProgramQuestionScreen> createState() => _ProgramQuestionScreenState();
}

class _ProgramQuestionScreenState extends State<ProgramQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _answers = {};
  bool _saving = false;

  List<Map<String, dynamic>> get _questions {
    switch (widget.programKey) {
      case 'lose':
        return [
          {'key': 'active', 'question': 'Yaşantında aktif hareket ediyor musun?', 'type': 'bool'},
          {'key': 'steps', 'question': 'Günlük ortalama kaç adım atıyorsun?', 'type': 'number'},
          {'key': 'meals', 'question': 'Günde kaç öğün yiyorsun?', 'type': 'select', 'options': ['2', '3', '4', '5+']},
          {'key': 'restriction', 'question': 'Diyet kısıtlaman var mı?', 'type': 'multi', 'options': ['Laktozsuz', 'Glutensiz', 'Vegan', 'Vejetaryen', 'Yok']},
          {'key': 'sleep', 'question': 'Uyku düzenin nasıl?', 'type': 'select', 'options': ['İyi', 'Orta', 'Kötü']},
          {'key': 'health', 'question': 'Sağlık problemi var mı?', 'type': 'text'},
        ];
      case 'gain':
        return [
          {'key': 'active', 'question': 'Günlük hareket seviyen nedir?', 'type': 'select', 'options': ['Düşük', 'Orta', 'Yüksek']},
          {'key': 'meals', 'question': 'Günde kaç öğün yiyorsun?', 'type': 'select', 'options': ['3', '4', '5+']},
          {'key': 'restriction', 'question': 'Diyet kısıtlaman var mı?', 'type': 'multi', 'options': ['Laktozsuz', 'Glutensiz', 'Vegan', 'Vejetaryen', 'Yok']},
          {'key': 'health', 'question': 'Sağlık problemi var mı?', 'type': 'text'},
        ];
      case 'maintain':
        return [
          {'key': 'active', 'question': 'Günlük hareket seviyen nedir?', 'type': 'select', 'options': ['Düşük', 'Orta', 'Yüksek']},
          {'key': 'meals', 'question': 'Günde kaç öğün yiyorsun?', 'type': 'select', 'options': ['2', '3', '4', '5+']},
          {'key': 'restriction', 'question': 'Diyet kısıtlaman var mı?', 'type': 'multi', 'options': ['Laktozsuz', 'Glutensiz', 'Vegan', 'Vejetaryen', 'Yok']},
        ];
      case 'fitness':
        return [
          {'key': 'sport_days', 'question': 'Haftada kaç gün spor yapıyorsun?', 'type': 'number'},
          {'key': 'sport_type', 'question': 'Hangi sporları yapıyorsun?', 'type': 'text'},
          {'key': 'goal', 'question': 'Hedefin nedir?', 'type': 'select', 'options': ['Kas', 'Dayanıklılık', 'Kilo', 'Diğer']},
        ];
      default:
        return [];
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _saving = true);
    
    final uid = AuthService.currentUser?.uid;
    if (uid == null) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı oturumu bulunamadı!')),
      );
      return;
    }

    try {
      // Firestore'a kaydet
      await UserService.saveProgramAnswers(uid, widget.programKey, _answers);
      
      // Kullanıcı profilini al
      final userProfile = await UserService.getProfile(uid);
      Map<String, dynamic>? profileData;
      if (userProfile != null) {
        profileData = userProfile.toJson();
      }

      // AI'dan diyet programlarını al
      final programsResponse = await AIService.generateDietPrograms(
        programKey: widget.programKey,
        answers: _answers,
        userProfile: profileData,
      );

      setState(() => _saving = false);

      if (programsResponse == null || programsResponse['programs'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diyet programları oluşturulamadı. Lütfen tekrar deneyin.')),
        );
        return;
      }

      // Diyet programları seçim ekranına git
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DietProgramsSelectionScreen(
              programKey: widget.programKey,
              programs: List<Map<String, dynamic>>.from(programsResponse['programs']),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata oluştu: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sorular')),
      body: _saving
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  ..._questions.map(_buildQuestionWidget).toList(),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Devam'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildQuestionWidget(Map<String, dynamic> q) {
    final key = q['key'];
    final type = q['type'];
    switch (type) {
      case 'bool':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q['question'], style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool?>(
                    value: true,
                    // ignore: deprecated_member_use
                    groupValue: _answers[key],
                    // ignore: deprecated_member_use
                    onChanged: (v) => setState(() => _answers[key] = v),
                    title: Text('Evet'),
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool?>(
                    value: false,
                    // ignore: deprecated_member_use
                    groupValue: _answers[key],
                    // ignore: deprecated_member_use
                    onChanged: (v) => setState(() => _answers[key] = v),
                    title: Text('Hayır'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        );
      case 'number':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TextFormField(
            decoration: InputDecoration(labelText: q['question']),
            keyboardType: TextInputType.number,
            validator: (v) => (v == null || v.isEmpty) ? 'Zorunlu' : null,
            onSaved: (v) => _answers[key] = int.tryParse(v ?? '') ?? 0,
          ),
        );
      case 'select':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: q['question']),
            items: (q['options'] as List<String>).map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
            initialValue: _answers[key],
            onChanged: (v) => setState(() => _answers[key] = v),
            validator: (v) => (v == null || v.isEmpty) ? 'Zorunlu' : null,
          ),
        );
      case 'multi':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q['question'], style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: (q['options'] as List<String>).map((opt) {
                final selected = (_answers[key] ?? <String>[]) as List<String>;
                return FilterChip(
                  label: Text(opt),
                  selected: selected.contains(opt),
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        (_answers[key] ??= <String>[]).add(opt);
                      } else {
                        (_answers[key] as List<String>).remove(opt);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
          ],
        );
      case 'text':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TextFormField(
            decoration: InputDecoration(labelText: q['question']),
            onSaved: (v) => _answers[key] = v ?? '',
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }
}