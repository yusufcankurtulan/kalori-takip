import 'package:flutter/material.dart';
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
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
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
    if (profile == null) return;
    setState(() {
      _heightCtrl.text = profile.height.toString();
      _weightCtrl.text = profile.weight.toString();
      _ageCtrl.text = profile.age.toString();
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

    final profile = UserProfile(
      id: user.uid,
      name: user.displayName ?? user.email ?? 'No Name',
      age: ageVal,
      height: heightVal,
      weight: weightVal,
      goal: 'maintain', // Default value
      activityLevel: 'sedentary', // Default value
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

                  // Height Field
                  TextField(
                    controller: _heightCtrl,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).height,
                      hintText: '170',
                      prefixIcon: Icon(Icons.height),
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
                      prefixIcon: Icon(Icons.scale),
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
                      prefixIcon: Icon(Icons.cake),
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
