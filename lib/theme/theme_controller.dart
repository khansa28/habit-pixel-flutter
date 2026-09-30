import 'package:flutter/material.dart';

import '../services/habit_database.dart';

class ThemeController extends ChangeNotifier {
  // ============================================================
  // SINGLETON
  // ============================================================

  ThemeController._();

  static final ThemeController instance =
      ThemeController._();

  // ============================================================
  // THEME MODE
  // ============================================================

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode =>
      _themeMode == ThemeMode.dark;

  // ============================================================
  // INITIALIZATION STATE
  // ============================================================

  bool _initialized = false;

  bool get isInitialized => _initialized;

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    // HabitDatabase is initialized by HabitStore.
    // Therefore this method is called after the database
    // initialization has completed.
    final savedTheme =
        HabitDatabase.instance.loadThemeMode();

    _themeMode =
        savedTheme == 'dark'
            ? ThemeMode.dark
            : ThemeMode.light;

    _initialized = true;

    notifyListeners();
  }

  // ============================================================
  // TOGGLE THEME
  // ============================================================

  Future<void> toggleTheme() async {
    _themeMode =
        isDarkMode
            ? ThemeMode.light
            : ThemeMode.dark;

    await _saveTheme();

    notifyListeners();
  }

  // ============================================================
  // SET THEME
  // ============================================================

  Future<void> setTheme(
    ThemeMode mode,
  ) async {
    if (_themeMode == mode) {
      return;
    }

    _themeMode = mode;

    await _saveTheme();

    notifyListeners();
  }

  // ============================================================
  // SAVE THEME
  // ============================================================

  Future<void> _saveTheme() async {
    await HabitDatabase.instance.saveThemeMode(
      isDarkMode ? 'dark' : 'light',
    );
  }
}