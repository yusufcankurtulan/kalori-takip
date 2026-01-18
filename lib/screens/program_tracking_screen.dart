import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../widgets/app_scaffold.dart';

class ProgramTrackingScreen extends StatefulWidget {
  final String programKey;
  const ProgramTrackingScreen({required this.programKey});

  @override
  State<ProgramTrackingScreen> createState() => _ProgramTrackingScreenState();
}

class _ProgramTrackingScreenState extends State<ProgramTrackingScreen> {
  bool? _todayFollowed;
  bool _saving = false;
  String? _statusMsg;

  @override
  void initState() {
    super.initState();
    print('Takip ekranı açıldı: ${widget.programKey}');
    _loadToday();
  }

  Future<void> _loadToday() async {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return;
    final today = DateTime.now();
    final key = 'track_${widget.programKey}_${today.year}_${today.month}_${today.day}_$uid';
    final prefs = await UserService.getPrefs();
    setState(() {
      _todayFollowed = prefs.getBool(key);
    });
  }

  Future<void> _saveToday(bool followed) async {
    setState(() { _saving = true; });
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return;
    final today = DateTime.now();
    final key = 'track_${widget.programKey}_${today.year}_${today.month}_${today.day}_$uid';
    final prefs = await UserService.getPrefs();
    await prefs.setBool(key, followed);
    setState(() {
      _todayFollowed = followed;
      _saving = false;
      _statusMsg = followed ? 'Tebrikler, bugün programa uyuldu!' : 'Bugün programa uyulmadı.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Program Takibi',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Bugün programa uyabildin mi?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 24),
            if (_todayFollowed == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _saving ? null : () => _saveToday(true),
                    icon: Icon(Icons.check, color: Colors.green),
                    label: Text('Evet'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green),
                  ),
                  ElevatedButton.icon(
                    onPressed: _saving ? null : () => _saveToday(false),
                    icon: Icon(Icons.close, color: Colors.red),
                    label: Text('Hayır'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red),
                  ),
                ],
              )
            else ...[
              Icon(_todayFollowed! ? Icons.check_circle : Icons.cancel, color: _todayFollowed! ? Colors.green : Colors.red, size: 48),
              SizedBox(height: 16),
              Text(_statusMsg ?? (_todayFollowed! ? 'Bugün uyuldu.' : 'Bugün uyulmadı.'), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white)),
            ],
          ],
        ),
      ),
    );
  }
}