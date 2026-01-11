import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/app_scaffold.dart';
import '../services/user_service.dart';
import '../l10n/app_localizations.dart';
import 'user_info_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    final body = FutureBuilder<Map<String, dynamic>>(
      future: _loadProfile(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snap.data ?? {};
        final age = (data['age'] ?? 0).toString();
        final height = (data['height'] ?? 0.0).toString();
        final weight = (data['weight'] ?? 0.0).toString();
        final gender = (data['gender'] ?? '').toString();

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
                  title: Text('User'),
                  subtitle: Text(gender.isNotEmpty ? gender : loc.profileNotSet),
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
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  await AuthService.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (r) => false,
                  );
                },
                child: Text(loc.logout),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              )
            ],
          ),
        );
      },
    );

    return AppScaffold(
      title: loc.profileTitle,
      currentIndex: 1,
      body: body,
    );
  }

  Future<Map<String, dynamic>> _loadProfile() async {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return {};
    return await UserService.getProfile(uid);
  }
}
