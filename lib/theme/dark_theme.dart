import 'package:flutter/material.dart';

// Dark Theme for Mental Health App
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.blueGrey[900]!,
    secondary: Colors.blueGrey[800]!,
  ),
);

// Dark Theme for Confession App
ThemeData confessionDarkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.purple[900]!,
    secondary: Colors.purple[800]!,
  ),
);
