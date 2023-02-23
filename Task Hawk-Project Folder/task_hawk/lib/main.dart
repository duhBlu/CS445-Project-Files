import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_hawk/controllers/db/db_helper.dart';
import 'package:task_hawk/services/theme_services.dart';
import 'package:task_hawk/ui/home_page.dart';
import 'package:task_hawk/ui/theme.dart';

Future<void> main() async {
  // Error checking
  WidgetsFlutterBinding.ensureInitialized();

  // Database Initialization
  await DBHelper.initDb();
  await GetStorage.init();

  // App Initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Hawk',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode:
          ThemeService().theme, // pulls theme object from ...lib/ui/theme.dart
      home:
          HomePage(), //Initial screen opened when running app from home_page.dart
    );
  }
}
