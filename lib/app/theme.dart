import 'package:flutter/material.dart';

ThemeData buildTheme() {
  const azul = Color(0xFF0A66C2);
  const celeste = Color(0xFFEAF5FF);

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: celeste,
    appBarTheme: const AppBarTheme(
      backgroundColor: celeste,
      foregroundColor: azul,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: azul,
        fontWeight: FontWeight.w800,
        fontSize: 32,
        letterSpacing: 0.4,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      isDense: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
