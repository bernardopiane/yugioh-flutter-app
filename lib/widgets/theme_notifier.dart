import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  late SharedPreferences _prefs;
  late bool _isDarkMode;

  ThemeNotifier(SharedPreferences prefs) {
    _prefs = prefs;
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
  }

  bool get isDarkMode => _isDarkMode;

  // set isDarkMode(bool value) {
  //   _isDarkMode = value;
  //   _prefs.setBool('isDarkMode', value);
  //   notifyListeners();
  // }

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _prefs.setBool("isDarkMode", _isDarkMode);
    notifyListeners();
  }
}
