import 'program_question_screen.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../widgets/app_scaffold.dart';
import '../l10n/app_localizations.dart';

class ProgramsScreen extends StatefulWidget {
  @override
  _ProgramsScreenState createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  String? _selected;

  final List<Map<String, String>> _options = [
    {'key': 'lose', 'label_en': 'Lose Weight', 'label_tr': 'Kilo Vermek'},
    {'key': 'gain', 'label_en': 'Gain Weight', 'label_tr': 'Kilo Almak'},
    {'key': 'maintain', 'label_en': 'Maintain Weight', 'label_tr': 'Kilosunu Koruma'},
    {'key': 'fitness', 'label_en': 'Active Fitness', 'label_tr': 'Aktif Spor'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return;
    final p = await UserService.getProgram(uid);
    if (mounted) {
      setState(() => _selected = p);
    }
  }

  Future<void> _save() async {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kullanıcı oturumu bulunamadı!')));
      return;
    }
    if (_selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lütfen bir program seçin!')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProgramQuestionScreen(programKey: _selected!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return AppScaffold(
      title: loc.menuProfileTitle,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('What do you want?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 12),
            ..._options.map((o) {
              final key = o['key']!;
              final label = Localizations.localeOf(context).languageCode == 'en' ? o['label_en']! : o['label_tr']!;
              return Card(
                child:
                    RadioListTile<String>(
                  value: key,
                  // ignore: deprecated_member_use
                  groupValue: _selected,
                  // ignore: deprecated_member_use
                  onChanged: (v) => setState(() => _selected = v),
                  title: Text(label),
                ),
              );
            }).toList(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _save,
              child: Text('Set Program'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Color(0xFF2E7D32)),
            )
          ],
        ),
      ),
    );
  }
}