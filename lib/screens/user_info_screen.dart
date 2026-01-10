import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import 'home_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  String _gender = 'Male';
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _error = 'Kullanıcı bulunamadı.';
        _loading = false;
      });
      return;
    }

    final height = double.tryParse(_heightCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final age = int.tryParse(_ageCtrl.text) ?? 0;

    final profile = {
      'height': height,
      'weight': weight,
      'age': age,
      'gender': _gender,
      'createdAt': DateTime.now().toIso8601String(),
    };

    try {
      await UserService.saveProfile(user.uid, profile);
      // Navigate to home and remove this screen from stack
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _error = 'Profil kaydedilirken hata oluştu.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil Bilgileri')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Lütfen temel bilgilerinizi girin', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 12),
                TextFormField(
                  controller: _heightCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Boy (cm)'),
                  validator: (v) {
                    final val = double.tryParse(v?.replaceAll(',', '.') ?? '');
                    if (val == null || val <= 0) return 'Geçerli bir boy girin';
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _weightCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Kilo (kg)'),
                  validator: (v) {
                    final val = double.tryParse(v?.replaceAll(',', '.') ?? '');
                    if (val == null || val <= 0) return 'Geçerli bir kilo girin';
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Yaş'),
                  validator: (v) {
                    final val = int.tryParse(v ?? '');
                    if (val == null || val <= 0) return 'Geçerli bir yaş girin';
                    return null;
                  },
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _gender,
                  items: ['Male', 'Female', 'Other']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _gender = v ?? 'Male'),
                  decoration: InputDecoration(labelText: 'Cinsiyet'),
                ),
                SizedBox(height: 20),
                if (_error != null)
                  Container(
                    padding: EdgeInsets.all(12),
                    color: Colors.red[200],
                    child: Text(_error!, style: TextStyle(color: Colors.white)),
                  ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Kaydet ve Devam Et'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
