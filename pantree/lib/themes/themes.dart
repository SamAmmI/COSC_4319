import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color.fromRGBO(25, 219, 138, 1),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(241, 244, 248, 1),
    titleTextStyle: TextStyle(
      fontFamily: 'Montserrat',
      color: Color.fromRGBO(20, 24, 27, 1),
      fontSize: 24,
      fontWeight: FontWeight.normal,
    ),
  ),
  colorScheme: const ColorScheme.light(
    background: Color.fromRGBO(241, 244, 248, 1),
    primary: Color.fromRGBO(20, 24, 27, 1),
    secondary: Colors.grey,
    tertiary: Colors.grey,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.grey),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'Montserrat',
      color: Color.fromRGBO(20, 24, 27, 1),
      fontSize: 24,
      fontWeight: FontWeight.normal,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Montserrat',
      color: Color.fromRGBO(20, 24, 27, 1),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Montserrat',
      color: Color.fromRGBO(20, 24, 27, 1),
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Montserrat',
      color: Color.fromRGBO(20, 24, 27, 1),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Montserrat',
      color: Color.fromRGBO(20, 24, 27, 1),
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Montserrat',
      color: Color.fromRGBO(20, 24, 27, 1),
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Montserrat',
      color: Color.fromRGBO(20, 24, 27, 1),
      fontSize: 8,
      fontWeight: FontWeight.normal,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.grey,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    fillColor: Color.fromRGBO(255, 255, 255, 1),
    filled: true,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color.fromRGBO(20, 24, 27, 1),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(20, 24, 27, 1),
    titleTextStyle: TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
  colorScheme: ColorScheme.dark(
    background: Color.fromRGBO(20, 24, 27, 1),
    primary: Colors.grey,
    secondary: Colors.grey,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.grey),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.grey[300],
      fontSize: 24,
      fontWeight: FontWeight.normal,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.grey[300],
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.grey[300],
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.grey[300],
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.grey[300],
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.grey[300],
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.grey[300],
      fontSize: 8,
      fontWeight: FontWeight.normal,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.grey[300],
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    fillColor: Color.fromRGBO(29, 36, 41, 1),
    filled: true,
  ),
);
