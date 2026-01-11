import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends ChangeNotifier {
  static const _prefKey = 'app_locale';
  Locale _locale = Locale('tr');

  Locale get locale => _locale;

  LocaleService() {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefKey);
      if (code != null && code.isNotEmpty) _locale = Locale(code);
      notifyListeners();
    } catch (e) {}
  }

  Future<void> setLocale(String code) async {
    _locale = Locale(code);
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, code);
    } catch (e) {}
  }
}
