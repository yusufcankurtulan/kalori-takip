import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../utils/input_validation.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  int _passwordStrength = 0;

  Future<void> _register() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();
    final confirmPass = _confirmPassCtrl.text.trim();

    // Comprehensive validation
    if (email.isEmpty || password.isEmpty || confirmPass.isEmpty) {
      setState(() => _error = 'Tüm alanları doldurunuz.');
      return;
    }

    // Validate email format
    final emailError = InputValidation.validateEmail(email);
    if (emailError != null) {
      setState(() => _error = emailError);
      return;
    }

    // Validate password with strong requirements
    final passwordErrors = InputValidation.validatePassword(password);
    if (passwordErrors.isNotEmpty) {
      setState(() => _error = passwordErrors.first);
      return;
    }

    // Confirm password match
    if (password != confirmPass) {
      setState(() => _error = 'Şifreler eşleşmiyor.');
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

  void _updatePasswordStrength(String password) {
    setState(() {
      _passwordStrength = InputValidation.calculatePasswordStrength(password);
    });
  }

  Color _getStrengthColor() {
    if (_passwordStrength < 30) return Colors.red;
    if (_passwordStrength < 50) return Colors.orange;
    if (_passwordStrength < 70) return Colors.yellow;
    if (_passwordStrength < 90) return Colors.lightGreen;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add, size: 80, color: Colors.white),
                  SizedBox(height: 24),
                  Text(
                    'Hesap Oluştur',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sağlık yolculuğuna başla',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 48),
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: false,
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.email, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscurePassword,
                    style: TextStyle(color: Colors.white),
                    onChanged: _updatePasswordStrength,
                    decoration: InputDecoration(
                      filled: false,
                      labelText: 'Şifre (min 8 karakter)',
                      labelStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.lock, color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  // Password strength indicator
                  if (_passCtrl.text.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _passwordStrength / 100,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor()),
                            minHeight: 4,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          InputValidation.getPasswordStrengthLabel(_passwordStrength),
                          style: TextStyle(
                            color: _getStrengthColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Password requirements
                    _buildPasswordRequirements(),
                  ],
                  SizedBox(height: 16),
                  TextField(
                    controller: _confirmPassCtrl,
                    obscureText: _obscureConfirm,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: false,
                      labelText: 'Şifreyi Onayla',
                      labelStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.lock, color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  if (_error != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _loading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                              ),
                            )
                          : Text(
                              'Kayıt Ol',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Zaten hesabın var mı? ',
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Giriş Yap',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _passCtrl.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequirementItem('En az 8 karakter', password.length >= 8),
        _buildRequirementItem('Büyük harf (A-Z)', password.contains(RegExp(r'[A-Z]'))),
        _buildRequirementItem('Küçük harf (a-z)', password.contains(RegExp(r'[a-z]'))),
        _buildRequirementItem('Rakam (0-9)', password.contains(RegExp(r'\d'))),
        _buildRequirementItem('Özel karakter (@$!%*?&)', password.contains(RegExp(r'[@$!%*?&]'))),
      ],
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isMet ? Colors.green : Colors.white54,
          size: 16,
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: isMet ? Colors.green[200] : Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
