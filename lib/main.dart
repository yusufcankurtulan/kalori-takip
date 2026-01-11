import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/user_info_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/camera_screen.dart';
import 'services/firebase_service.dart';
import 'services/user_service.dart';
import 'services/theme_service.dart';
import 'services/locale_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => LocaleService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeSvc = Provider.of<ThemeService>(context);
    final localeSvc = Provider.of<LocaleService>(context);

    return MaterialApp(
      title: 'Kalori Takip',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr'), Locale('en')],
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.transparent,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      themeMode: themeSvc.themeMode,
      locale: localeSvc.locale,
      routes: {
        '/home': (_) => HomeScreen(),
        '/profile': (_) => ProfileScreen(),
        '/settings': (_) => SettingsScreen(),
        '/login': (_) => LoginScreen(),
        '/user_info': (_) => UserInfoScreen(),
        '/camera': (_) => CameraScreen(),
      },
      home: _AppBackground(child: AuthGate()),
    );
  }
}

class _AppBackground extends StatelessWidget {
  final Widget child;
  
  const _AppBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        ),
      ),
      child: child,
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;
        if (user == null) return LoginScreen();

        // If user is signed in we need to check whether they've completed profile
        return FutureBuilder<bool>(
          future: UserService.isProfileComplete(user.uid),
          builder: (context, profSnap) {
            if (profSnap.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final completed = profSnap.data ?? false;
            if (!completed) {
              return UserInfoScreen();
            }

            return HomeScreen();
          },
        );
      },
    );
  }
}
