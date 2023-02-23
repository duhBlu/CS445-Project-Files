import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// handling the boolean logic data to keep track of light/dark mode.
// please don't modify this
class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);
  // if value exists, then return that one, otherwise return false
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  // 'get theme' allows you to get the variable 'theme' stored somewhere else,
  //  without having to import that library
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
