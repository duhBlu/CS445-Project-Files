import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color lightBackground = Color.fromARGB(255, 240, 240, 240);
const Color darkBackground = Color.fromARGB(255, 50, 50, 50);
const Color lightText = Color.fromARGB(255, 33, 33, 33);
const Color darkText = Color.fromARGB(255, 240, 240, 240);
const Color lightAccent = Color.fromARGB(255, 204, 51, 51);
const Color darkAccent = Color.fromARGB(255, 171, 18, 18);
const Color appbarcolor = Color.fromARGB(255, 114, 20, 20);

List<Color> customColors = [
  Color.fromARGB(255, 94, 152, 173),
  Color.fromARGB(255, 166, 212, 135),
  Color.fromARGB(255, 232, 121, 87),
  Color.fromARGB(255, 183, 104, 162),
  Color.fromARGB(255, 255, 170, 83),
];

class Themes {
  static final light = ThemeData(
    appBarTheme: const AppBarTheme(
      color: appbarcolor,
    ),
    colorScheme: const ColorScheme(
      background: lightBackground,
      onBackground: lightText,
      primary: lightBackground,
      onPrimary: lightText,
      secondary: lightAccent,
      onSecondary: lightText,
      surface: lightBackground,
      onSurface: lightText,
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
  );

  static final dark = ThemeData(
    appBarTheme: const AppBarTheme(
      color: appbarcolor,
    ),
    colorScheme: const ColorScheme(
      background: darkBackground,
      onBackground: darkText,
      primary: darkBackground,
      onPrimary: darkText,
      secondary: darkAccent,
      onSecondary: darkText,
      surface: darkBackground,
      onSurface: darkText,
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
  );
}

// Text style for header date
TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? darkText : lightText),
  );
}

// Text style for header text
TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 30,
        color: Get.isDarkMode ? darkAccent : lightAccent,
        fontWeight: FontWeight.bold),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 16,
        color: Get.isDarkMode ? darkText : lightText,
        fontWeight: FontWeight.bold),
  );
}
