import 'package:flutter/material.dart';
//This file is for abstraction and easily keeping the app looking consistent

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.grey,
  ),
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: Colors.black,
    secondary: Colors.grey,
    tertiary: Colors.grey,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.grey)
  )
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.white,
    secondary: Colors.grey[600]!,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.grey)
  )
);

