import 'package:flutter/material.dart';

final theme = ThemeData(
  appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF93D679)),
  dividerColor: const Color(0xFF93D679),
  primaryColorLight: const Color(0xFF93D679),
  primaryColor: const Color(0xFF0C1B33),
  // colorScheme: const ColorScheme.light(secondary: Color(0xFF0C1B33)),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    linearMinHeight: 1,
    color: Color(0xFF93D679),
  ),
  expansionTileTheme: const ExpansionTileThemeData(
    iconColor: Color(0xFF93D679),
    textColor: Color(0xFF93D679),
    collapsedShape: Border.symmetric(),
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStatePropertyAll(EdgeInsets.all(6)),
      // textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 17)),
      side: MaterialStatePropertyAll(BorderSide(color: Color(0xFF0C1B33))),
      shape: MaterialStatePropertyAll(
        // BeveledRectangleBorder(
        //   borderRadius: BorderRadius.circular(10),
        // ),
        StadiumBorder(),
      ),
      foregroundColor: MaterialStatePropertyAll(Color(0xFF0C1B33)),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
      // textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 20)),
      backgroundColor: MaterialStatePropertyAll(Color(0xFF0C1B33)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    prefixIconColor: const Color(0xFF0C1B33),
    prefixStyle: const TextStyle(color: Color(0xFF0C1B33), fontSize: 20),
    labelStyle: const TextStyle(color: Color(0xFF0C1B33)),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF93D679)),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF0C1B33)),
      borderRadius: BorderRadius.circular(8),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
