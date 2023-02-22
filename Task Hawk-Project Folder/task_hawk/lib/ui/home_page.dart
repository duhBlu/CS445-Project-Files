import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_hawk/services/notification_services.dart';
import 'package:task_hawk/ui/theme.dart';
import '../services/theme_services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'complex_example.dart';

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
      appBar: AppBar(
        leading: GestureDetector(
          // refreshes the page state on tap, so pages react dynamically
          onTap: () {
            setState(() {
              ThemeService().switchTheme();
            });

            NotifyHelper notifyHelper = NotifyHelper();
            notifyHelper.displayNotification(
                title: "Theme Changed",
                body: Get.isDarkMode
                    ? "Activated Light Theme"
                    : "Activated Dark Theme");
          },
          // dark/light mode change icon logic
          // ignore: sort_child_properties_last
          child: Icon(
            Get.isDarkMode
                ? Icons.nightlight_outlined
                : Icons.wb_sunny_outlined,
            color: Get.isDarkMode ? Colors.white : Colors.white,
            size: 25,
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
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: subHeadingStyle,
                    ),
                    Text(
                      "Upcoming Tasks",
                      style: headingStyle,
                    ),
                  ],
                ),
              )
            ],
          )
        ],

        /*
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const SizedBox(height: 12.0),
            constr ElevatedButton(
              child: Text('Sign Up'),
              onPressed: null,
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Sign In'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableComplexExample()),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),*/
      ),
    );
  }
}
