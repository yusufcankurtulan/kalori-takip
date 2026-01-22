import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../services/user_service.dart';
import 'home_screen.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();
  DateTime? _selectedBirthDate;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _birthDateCtrl.dispose();
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
    if (profile == null) return;
    setState(() {
      _heightCtrl.text = profile.height.toString();
      _weightCtrl.text = profile.weight.toString();
      if (profile.birthDate != null) {
        _birthDateCtrl.text = profile.birthDate!;
      }
      if (profile.firstName != null) {
        _firstNameCtrl.text = profile.firstName!;
      }
      if (profile.lastName != null) {
        _lastNameCtrl.text = profile.lastName!;
      }
    });
  }

  Future<void> _submit() async {
    // Validate inputs
    final firstName = _firstNameCtrl.text.trim();
    final lastName = _lastNameCtrl.text.trim();
    final heightVal = double.tryParse(_heightCtrl.text.replaceAll(',', '.'));
    final weightVal = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));

    final loc = AppLocalizations.of(context);
    if (firstName.isEmpty || lastName.isEmpty) {
      setState(() => _error = 'Lütfen ad ve soyad giriniz.');
      return;
    }
    if (heightVal == null || heightVal <= 0) {
      setState(() => _error = loc.enterValidHeight);
      return;
    }
    if (weightVal == null || weightVal <= 0) {
      setState(() => _error = loc.enterValidWeight);
      return;
    }
    if (_selectedBirthDate == null) {
      // Mevcut çeviriyi kullanmak için aynı hata anahtarını kullanıyoruz.
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

    // Doğum tarihinden yaşı hesapla
    final now = DateTime.now();
    int ageVal = now.year - _selectedBirthDate!.year;
    final thisYearsBirthday =
        DateTime(now.year, _selectedBirthDate!.month, _selectedBirthDate!.day);
    if (thisYearsBirthday.isAfter(now)) {
      ageVal--;
    }
    final birthDateStr =
        '${_selectedBirthDate!.day.toString().padLeft(2, '0')}.'
        '${_selectedBirthDate!.month.toString().padLeft(2, '0')}.'
        '${_selectedBirthDate!.year}';

    final fullName = '$firstName $lastName'.trim();

    final profile = UserProfile(
      id: user.uid,
      name: fullName.isEmpty
          ? (user.displayName ?? user.email ?? 'No Name')
          : fullName,
      firstName: firstName,
      lastName: lastName,
      age: ageVal,
      height: heightVal,
      weight: weightVal,
      goal: 'maintain', // Default value
      activityLevel: 'sedentary', // Default value
      birthDate: birthDateStr,
    );

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
    final theme = Theme.of(context);
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
                    child: Icon(Icons.person_add, size: 80, color: AppTheme.textColor),
                  ),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).profileHeaderTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).profileHeaderSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  SizedBox(height: 32),

                  // First Name Field
                  TextField(
                    controller: _firstNameCtrl,
                    keyboardType: TextInputType.name,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: false,
                      labelText: 'Ad',
                      labelStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.person, color: Colors.white70),
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

                  // Last Name Field
                  TextField(
                    controller: _lastNameCtrl,
                    keyboardType: TextInputType.name,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: false,
                      labelText: 'Soyad',
                      labelStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.person_outline, color: Colors.white70),
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

                  // Height Field (cm)
                  TextField(
                    controller: _heightCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: false,
                      labelText: AppLocalizations.of(context).height,
                      labelStyle: TextStyle(color: Colors.white70),
                      hintText: '170',
                      prefixIcon: Icon(Icons.height, color: Colors.white70),
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

                  // Weight Field (kg)
                  TextField(
                    controller: _weightCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: false,
                      labelText: AppLocalizations.of(context).weight,
                      labelStyle: TextStyle(color: Colors.white70),
                      hintText: '70',
                      prefixIcon: Icon(Icons.scale, color: Colors.white70),
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

                  // Birth Date Field
                  TextField(
                    controller: _birthDateCtrl,
                    readOnly: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: false,
                      labelText: 'Doğum Tarihi',
                      labelStyle: TextStyle(color: Colors.white70),
                      hintText: 'GG.AA.YYYY',
                      prefixIcon: Icon(Icons.cake, color: Colors.white70),
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
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final now = DateTime.now();
                      final initialDate = _selectedBirthDate ??
                          DateTime(now.year - 25, now.month, now.day);
                      final firstDate = DateTime(now.year - 100);
                      final lastDate = now;
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedBirthDate = picked;
                          _birthDateCtrl.text =
                              '${picked.day.toString().padLeft(2, '0')}.'
                              '${picked.month.toString().padLeft(2, '0')}.'
                              '${picked.year}';
                        });
                      }
                    },
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
                    child: _loading
                            ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(AppLocalizations.of(context).saveAndContinue),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}
