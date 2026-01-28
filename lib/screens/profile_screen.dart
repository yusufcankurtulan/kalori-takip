import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../widgets/app_scaffold.dart';
import '../services/user_service.dart';
import '../l10n/app_localizations.dart';
import 'user_info_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    final body = FutureBuilder<UserProfile?>(
      future: _loadProfile(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final userProfile = snap.data;
        final name = userProfile?.name ?? 'User';
        final age = userProfile?.age.toString() ?? '0';
        final height = userProfile?.height.toString() ?? '0.0';
        final weight = userProfile?.weight.toString() ?? '0.0';

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(loc.userInfo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(name),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => UserInfoScreen()));
                    },
                    child: Text('Edit'),
                    style: TextButton.styleFrom(foregroundColor: Color(0xFF2E7D32)),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(loc.age),
                  subtitle: Text(age == '0' ? loc.profileNotSet : age),
                ),
              ),
              SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: Icon(Icons.height),
                  title: Text(loc.height),
                  subtitle: Text((height == '0.0' || height == '0') ? loc.profileNotSet : height),
                ),
              ),
              SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: Icon(Icons.fitness_center),
                  title: Text(loc.weight),
                  subtitle: Text((weight == '0.0' || weight == '0') ? loc.profileNotSet : weight),
                ),
              ),
            ],
          ),
        );
      },
    );

    return AppScaffold(
      title: loc.profileTitle,
      currentIndex: 2,
      body: body,
    );
  }

  Future<UserProfile?> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return await UserService.getProfile(uid);
  }
}

