import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_hawk/services/notification_services.dart';
import 'package:task_hawk/ui/theme.dart';
import '../services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: const [
          Text(
            "Theme Data",
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

_appBar() {
  return AppBar(
    leading: GestureDetector(
      onTap: () {
        ThemeService().switchTheme();

        NotifyHelper notifyHelper = NotifyHelper();
        notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode
                ? "Activated Light Theme"
                : "Activated Dark Theme");
      },
      // ignore: sort_child_properties_last
      child: Icon(
        //Get.isDarkMode ? Icons.nightlife_rounded : Icons.wb_sunny_rounded,
        Icons.nightlife_rounded,
        color: Get.isDarkMode ? Colors.white : Colors.black,

        size: 20,
      ),
    ),
    actions: const [
      CircleAvatar(
        backgroundImage: AssetImage("images/appicon.png"),
      ),
      SizedBox(
        width: 20,
      ),
    ],
  );
}