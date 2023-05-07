import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_hawk/controllers/db/db_helper.dart';
import 'package:task_hawk/services/theme_services.dart';
import 'package:task_hawk/ui/home_page.dart';
import 'package:task_hawk/ui/theme.dart';
import 'controllers/task_controller.dart';
import 'controllers/task_list_controller.dart';

/// This is the main entry point of the Flutter application.
/// It initializes the database, GetStorage and the application's root widget.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  //await DBHelper.resetDatabase(); // UNCOMMENT ONLY IF YOU NEED TO CLEAR THE DATABASE
  await GetStorage.init();
  runApp(const MyApp());
}

/// The root widget of the application.
///
/// This StatelessWidget initializes and sets the application's theme,
/// dark theme, and theme mode using the [ThemeService].
/// It also sets the application's home screen as [HomePage].
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
