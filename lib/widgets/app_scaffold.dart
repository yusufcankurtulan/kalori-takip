import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final int currentIndex;

  const AppScaffold({Key? key, required this.body, this.title, this.currentIndex = 0}) : super(key: key);

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/my-programs');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context);
    final labelHome = appLoc.homeTitle;
    final labelProfile = appLoc.profileTitle;
    final labelSettings = appLoc.settingsTitle;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
            )
          : null,
      body: SafeArea(child: body),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppTheme.darkBottomBarTop, AppTheme.darkBottomBarBottom]
                : [AppTheme.primaryColor, AppTheme.secondaryColor],
          ),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, -2))],
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (i) => _onTap(context, i),
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: labelHome),
              BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: appLoc.myProgramsTitle),
              BottomNavigationBarItem(icon: Icon(Icons.person), label:labelProfile),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: labelSettings),
            ],
          ),
        ),
      ),
    );
  }
}