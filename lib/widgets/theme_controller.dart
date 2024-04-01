import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';

class ThemeController extends GetxController {
  late SharedPreferences _prefs;
  late RxBool _isDarkMode;

  @override
  void onInit() {
    super.onInit();
    _isDarkMode = false.obs; // Initialize as false
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode.value = _prefs.getBool('isDarkMode') ?? false;
  }

  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get currentTheme => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _prefs.setBool("isDarkMode", _isDarkMode.value);
  }
}

