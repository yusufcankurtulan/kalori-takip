import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

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
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 2:
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: title != null
            ? AppBar(
                title: Text(title!),
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            : null,
        body: SafeArea(child: body),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, -2))],
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedIconTheme: IconThemeData(size: 28),
              onTap: (i) => _onTap(context, i),
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: labelHome),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: labelProfile),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: labelSettings),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
