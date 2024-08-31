import 'package:flutter/material.dart';

// light theme
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 120, 120, 120),
    secondary: Color.fromARGB(255, 214, 214, 214),
    inversePrimary: Color.fromARGB(255, 45, 45, 45),
    surface: Color.fromARGB(255, 227, 227, 227),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 187, 187, 187),
    secondary: const Color.fromARGB(255, 33, 33, 33),
    inversePrimary: Colors.grey.shade100,
    surface: const Color.fromARGB(255, 19, 19, 19),
  ),
);
