import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  static final _instance = AppTheme._();

  AppTheme._();

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.grey),
          bodySmall: TextStyle(fontSize: 14, color: Colors.grey),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.grey),
          displaySmall: TextStyle(fontSize: 14, color: Colors.grey),
          titleLarge: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  ThemeData get darkTheme => ThemeData(
        scaffoldBackgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.grey[200]),
          displayMedium: TextStyle(fontSize: 16, color: Colors.grey[200]),
          bodySmall: TextStyle(fontSize: 14, color: Colors.grey[200]),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.grey[200]),
          displaySmall: TextStyle(fontSize: 14, color: Colors.grey[200]),
          titleLarge: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  factory AppTheme() {
    return _instance;
  }
}
