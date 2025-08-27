import 'package:flutter/material.dart';

class AppThemes {
  // 🔹 Dark theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF0D1B2A),
    scaffoldBackgroundColor: const Color(0xFF0D1B2A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D1B2A),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF1B263B),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    cardColor: const Color(0xFF1B263B),
    dividerColor: Colors.white24,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white12,
      labelStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );

  // 🔹 Light theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF2193b0),
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2193b0),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2193b0),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      bodyLarge: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
    cardColor: Colors.white,
    dividerColor: Colors.grey,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      labelStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2193b0),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );
}
