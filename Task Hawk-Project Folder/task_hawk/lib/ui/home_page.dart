import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_hawk/services/notification_services.dart';
import 'package:task_hawk/ui/add_task_page.dart';
import 'package:task_hawk/ui/theme.dart';
import 'package:task_hawk/ui/widgets/add_task_button.dart';
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
  DateTime __selectedDate = DateTime.now();
  var notifyHelper;

  // Initialize the Notification services
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  // Home Page contents
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: __addAppBar(), // custom app bar
      body: Column(
        children: [
          __addTaskBar(), // custom header bar
          __addDateBar(), // custom widget that adds the sliding calendar
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

  // custom function returns DatePicker widget within a Container
  __addDateBar() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10,
      ),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: appbarcolor,
        selectedTextColor: Colors.white,

        // Date bar text style
        dateTextStyle: GoogleFonts.lato(
          fontSize: 25,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dayTextStyle: GoogleFonts.lato(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
        monthTextStyle: GoogleFonts.lato(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
        // logic for handling selected dates
        onDateChange: (date) {
          __selectedDate = date;
        },
      ),
    );
  }

  // container including current date and the task button
  __addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
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
          ),
          CreateTaskButton(
            label: "+ Add Task",
            onTap: () => Get.to(
                AddTaskPage()), // on tap, opens new page defined in /lib/ui/widgets/add_task_page.dart
          )
        ],
      ),
    );
  }

// returns an AppBar widget containing dark/light mode button, and a sample user avatar
  __addAppBar() {
    return AppBar(
      leading: GestureDetector(
        // refreshes the page state on tap, so pages react dynamically
        onTap: () {
          setState(() {
            ThemeService().switchTheme();
          });
          // initialize notifications, call NotifyHelper defined in /lib/services/notification_services.dart
          NotifyHelper notifyHelper = NotifyHelper();
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Activated Light Theme"
                  : "Activated Dark Theme");
        },

        // dark/light mode change icon logic
        child: Icon(
          Get.isDarkMode ? Icons.nightlight_outlined : Icons.wb_sunny_outlined,
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
    );
  }
}
