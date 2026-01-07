import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();

    // Basic client-side validation
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Email ve şifre boş olamaz.');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Şifre en az 6 karakter olmalıdır.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.register(email, password);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Show more user-friendly and actionable error messages
      String msg = e.message ?? 'Bilinmeyen hata';
      setState(() {
        _error = '[${e.code}] $msg';
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Şifre (min 6)'),
            ),
            SizedBox(height: 16),
            if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 8),
            ElevatedButton(onPressed: _loading ? null : _register, child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Kayıt Ol')),
          ],
        ),
      ),
    );
  }
}
