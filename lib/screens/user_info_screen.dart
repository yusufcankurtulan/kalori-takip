import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import 'home_screen.dart';
import '../l10n/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final profile = await UserService.getProfile(uid);
    if (profile.isEmpty) return;
    setState(() {
      final h = profile['height'];
      final w = profile['weight'];
      final a = profile['age'];
      final g = profile['gender'];
      if (h != null && h is num) _heightCtrl.text = h.toString();
      if (w != null && w is num) _weightCtrl.text = w.toString();
      if (a != null && a is num) _ageCtrl.text = a.toString();
      if (g != null && g is String && g.isNotEmpty) _gender = g;
    });
  }

  Future<void> _submit() async {
    // Validate inputs
    final heightVal = double.tryParse(_heightCtrl.text.replaceAll(',', '.'));
    final weightVal = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));
    final ageVal = int.tryParse(_ageCtrl.text);

    final loc = AppLocalizations.of(context);
    if (heightVal == null || heightVal <= 0) {
      setState(() => _error = loc.enterValidHeight);
      return;
    }
    if (weightVal == null || weightVal <= 0) {
      setState(() => _error = loc.enterValidWeight);
      return;
    }
    if (ageVal == null || ageVal <= 0) {
      setState(() => _error = loc.enterValidAge);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _error = loc.userNotFound;
        _loading = false;
      });
      return;
    }

    final profile = {
      'height': heightVal,
      'weight': weightVal,
      'age': ageVal,
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
        _error = loc.profileSaveError;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Icon and Title
                  Center(
                    child: Icon(Icons.person_add, size: 80, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).profileHeaderTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).profileHeaderSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  SizedBox(height: 32),

                  // Height Field
                  TextField(
                    controller: _heightCtrl,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).height,
                      hintText: '170',
                      prefixIcon: Icon(Icons.height, color: Color(0xFF2E7D32)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Weight Field
                  TextField(
                    controller: _weightCtrl,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).weight,
                      hintText: '70',
                      prefixIcon: Icon(Icons.scale, color: Color(0xFF2E7D32)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Age Field
                  TextField(
                    controller: _ageCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).age,
                      hintText: '25',
                      prefixIcon: Icon(Icons.cake, color: Color(0xFF2E7D32)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Gender Dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      initialValue: _gender,
                      items: [
                        DropdownMenuItem(value: 'Male', child: Row(children: [Icon(Icons.male, color: Color(0xFF2E7D32)), SizedBox(width: 8), Text(AppLocalizations.of(context).genderMale)])),
                        DropdownMenuItem(value: 'Female', child: Row(children: [Icon(Icons.female, color: Color(0xFF2E7D32)), SizedBox(width: 8), Text(AppLocalizations.of(context).genderFemale)])),
                        DropdownMenuItem(value: 'Other', child: Row(children: [Icon(Icons.wc, color: Color(0xFF2E7D32)), SizedBox(width: 8), Text(AppLocalizations.of(context).genderOther)])),
                      ],
                      onChanged: (v) => setState(() => _gender = v ?? 'Male'),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).gender,
                        prefixIcon: Icon(Icons.wc, color: Color(0xFF2E7D32)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Error Message
                  if (_error != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  if (_error != null) SizedBox(height: 12),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _loading ? null : _submit,
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
                              valueColor: AlwaysStoppedAnimation(Color(0xFF2E7D32)),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context).saveAndContinue,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}
