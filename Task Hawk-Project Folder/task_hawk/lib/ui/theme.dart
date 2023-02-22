import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color color1 = Color.fromARGB(255, 196, 196, 196);
const Color color2 = Color.fromARGB(255, 33, 33, 33);
const Color appbarcolor = Color.fromARGB(255, 114, 20, 20);

class Themes {
  static final light = ThemeData(
    appBarTheme: const AppBarTheme(
      color: appbarcolor,
    ),
    colorScheme: const ColorScheme(
      background: color1,
      onBackground: color2,
      primary: color1,
      onPrimary: color2,
      secondary: color1,
      onSecondary: color2,
      surface: color1,
      onSurface: color2,
      error: color1,
      onError: color2,
      brightness: Brightness.light,
    ),
  );

  static final dark = ThemeData(
    appBarTheme: const AppBarTheme(
      color: appbarcolor,
    ),
    colorScheme: const ColorScheme(
      background: color2,
      onBackground: color1,
      primary: color2,
      onPrimary: color1,
      secondary: color2,
      onSecondary: color1,
      surface: color2,
      onSurface: color1,
      error: color2,
      onError: color1,
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
        color: Get.isDarkMode ? Colors.black : Colors.white),
  );
}

// Text style for header text
TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 30,
        color: Get.isDarkMode
            ? const Color.fromARGB(255, 61, 0, 0)
            : const Color.fromARGB(255, 135, 10, 10),
        fontWeight: FontWeight.bold),
  );
}
