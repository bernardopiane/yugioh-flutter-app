import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { light, dark }

class ThemeController extends GetxController {
  late SharedPreferences _prefs;
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  // Light theme
  final lightTheme = ThemeData.light();
// Dark theme
  final darkTheme = ThemeData.dark();

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final String? savedTheme = _prefs.getString('theme');
    if (savedTheme != null) {
      themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      _saveThemeToPrefs('dark');
    } else {
      themeMode.value = ThemeMode.light;
      _saveThemeToPrefs('light');
    }
    debugPrint("Theme changed to ${themeMode.value}");
  }

  Future<void> _saveThemeToPrefs(String theme) async {
    await _prefs.setString('theme', theme);
  }
}
