import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeType { purple, blue, green, orange, dark }

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = "selected_theme_mode";

  static AppThemeType _currentTheme = AppThemeType.purple;

  static AppThemeType get currentTheme => _currentTheme;

  static ThemeProvider? _instance;

  ThemeProvider() {
    _instance = this;
    _loadTheme();
  }

  static ThemeProvider get instance {
    _instance ??= ThemeProvider();
    return _instance!;
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeStr = prefs.getString(_themeKey);
    if (savedThemeStr != null) {
      _currentTheme = AppThemeType.values.firstWhere(
        (t) => t.toString() == savedThemeStr,
        orElse: () => AppThemeType.purple,
      );
      notifyListeners();
    }
  }

  Future<void> setTheme(AppThemeType themeType) async {
    _currentTheme = themeType;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeType.toString());
  }

  static Color get activePrimaryColor {
    switch (_currentTheme) {
      case AppThemeType.purple:
        return Colors.purple;
      case AppThemeType.blue:
        return Colors.blue.shade800;
      case AppThemeType.green:
        return Colors.green.shade800;
      case AppThemeType.orange:
        return Colors.orange.shade800;
      case AppThemeType.dark:
        return Colors.tealAccent.shade400;
    }
  }

  static Color get activeBgcolorApp {
    switch (_currentTheme) {
      case AppThemeType.purple:
        return Colors.purple.shade700;
      case AppThemeType.blue:
        return Colors.blue.shade700;
      case AppThemeType.green:
        return Colors.green.shade700;
      case AppThemeType.orange:
        return Colors.orange.shade700;
      case AppThemeType.dark:
        return const Color(0xFF121212);
    }
  }

  static Color get activeBgcolorTitlebar {
    switch (_currentTheme) {
      case AppThemeType.purple:
        return Colors.purple.shade300;
      case AppThemeType.blue:
        return Colors.blue.shade300;
      case AppThemeType.green:
        return Colors.green.shade300;
      case AppThemeType.orange:
        return Colors.orange.shade300;
      case AppThemeType.dark:
        return const Color.fromARGB(255, 97, 97, 97);
    }
  }

  ThemeData getThemeData() {
    final isDark = _currentTheme == AppThemeType.dark;

    // Base colors
    final scaffoldBg = activeBgcolorTitlebar;

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: scaffoldBg,
      fontFamily: "Muli",
      appBarTheme: AppBarTheme(
        backgroundColor: activeBgcolorTitlebar,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : const Color(0XFF8B8B8B),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF757575),
        ),
        bodyMedium: TextStyle(
          color: isDark ? Colors.white70 : const Color(0xFF757575),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 42,
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: isDark ? Colors.white38 : const Color(0xFF757575),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: activePrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: isDark ? Colors.white38 : const Color(0xFF757575),
          ),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
