import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import '../services/locale_service.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/app_scaffold.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeSvc = Provider.of<ThemeService>(context);
    final localeSvc = Provider.of<LocaleService>(context);
    final loc = AppLocalizations.of(context);

    final body = SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text(loc.logout),
                onTap: () async {
                  await AuthService.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (r) => false,
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(Icons.language),
                title: Text(loc.language),
                trailing: DropdownButton<String>(
                  value: localeSvc.locale.languageCode,
                  items: [
                    DropdownMenuItem(child: Text('Türkçe'), value: 'tr'),
                    DropdownMenuItem(child: Text('English'), value: 'en'),
                  ],
                  onChanged: (v) {
                    if (v != null) localeSvc.setLocale(v);
                  },
                ),
              ),
            ),
            SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(Icons.brightness_6),
                title: Text(loc.theme),
                trailing: Switch(
                  value: themeSvc.isDark,
                  onChanged: (v) => themeSvc.toggle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return AppScaffold(
      title: loc.settingsTitle,
      currentIndex: 3,
      body: body,
    );
  }
}
