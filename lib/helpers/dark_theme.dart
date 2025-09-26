import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    surface: Color.fromARGB(255, 8, 26, 75),
    primary: Color.fromARGB(255, 82, 0, 255),
    secondary: const Color.fromARGB(255, 82, 0, 255),
    tertiary: const Color.fromARGB(255, 44, 51, 113),
    inversePrimary: Colors.grey.shade300,
  ),

  // appBarTheme: AppBarTheme(
  //   centerTitle: true,
  //   backgroundColor: Colors.transparent,
  //   foregroundColor: Colors.grey.shade300,
  // ),
);
