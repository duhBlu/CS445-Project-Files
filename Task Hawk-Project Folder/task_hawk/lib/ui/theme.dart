import 'package:flutter/material.dart';

const Color color1 = Color.fromARGB(255, 255, 255, 255);
const Color color2 = Color.fromARGB(255, 245, 243, 244);
const Color color3 = Color.fromARGB(255, 211, 211, 211);
const Color color4 = Color.fromARGB(255, 177, 167, 166);
const Color color5 = Color.fromARGB(255, 229, 56, 59);
const Color color6 = Color.fromARGB(255, 186, 24, 27);
const Color color7 = Color.fromARGB(255, 164, 22, 27);
const Color color8 = Color.fromARGB(255, 102, 7, 9);
const Color color9 = Color.fromARGB(255, 22, 26, 29);
const Color color10 = Color.fromARGB(255, 11, 9, 10);

const Color darkAppBarClr = color8;
const Color lightAppBarClr = color5;

class Themes {
  static final light = ThemeData(
    appBarTheme: const AppBarTheme(
      color: lightAppBarClr,
    ),
    colorScheme: const ColorScheme(
      background: color10,
      onBackground: color3,
      primary: color9,
      onPrimary: color3,
      secondary: color9,
      onSecondary: color3,
      surface: color3,
      onSurface: color9,
      error: color3,
      onError: color9,
      brightness: Brightness.light,
    ),
  );

  static final dark = ThemeData(
    appBarTheme: const AppBarTheme(
      color: darkAppBarClr,
    ),
    colorScheme: const ColorScheme(
      background: color10,
      onBackground: color3,
      primary: color8,
      onPrimary: color3,
      secondary: color7,
      onSecondary: color3,
      surface: color9,
      onSurface: color3,
      error: color9,
      onError: color3,
      brightness: Brightness.dark,
    ),
  );
}
