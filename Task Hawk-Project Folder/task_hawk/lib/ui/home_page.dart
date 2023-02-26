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
//import 'complex_example.dart';
import 'package:task_hawk/table_calendar.dart';

// for debugging
import 'dart:developer' as developer;

// hacky calendar utils
import 'package:task_hawk/src/shared/utils2.dart';

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

    // calendar day and events display
    _selectedDay = _focusedDay.value;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  // init calendar vars
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime? _selectedDay;

  late PageController _pageController;

  List<Event> _getEventsForDay(DateTime day) {
    return (kEvents[day] ?? []) as List<Event>;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay.value = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  // Home Page contents
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: __addAppBar(), // custom app bar
      body: Column(
        children: [
          __addTaskBar(), // custom header bar

          //__addDateBar(), // custom widget that adds the sliding calendar

          // hiding datebar when in calendar mode
          if (_calendarFormat == CalendarFormat.week) (__addDateBar()),

          // calendar junk
          ValueListenableBuilder<DateTime>(
            valueListenable: _focusedDay,
            builder: (context, DateTime value, _) {
              return _CalendarHeader(
                focusedDay: value,
                clearButtonVisible: true, //canClearSelection,
                format: _calendarFormat,
                onTodayButtonTap: () {
                  developer.log('Goto Today', name: 'Goto Today');
                  _selectedDay = DateTime.now();
                  setState(() => _focusedDay.value = DateTime.now());
                },
                onAddEventTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskPage()),
                ),
                onClearButtonTap: () {
                  developer.log('Remove Event', name: 'Remove Event');
                },
                onLeftArrowTap: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                onRightArrowTap: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                onFormatButtonTap: () {
                  if (_calendarFormat == CalendarFormat.month) {
                    _calendarFormat = CalendarFormat.week;
                  } else {
                    _calendarFormat = CalendarFormat.month;
                  }

                  setState(() {
                    _selectedEvents.value = [];
                  });
                },
              );
            },
          ),
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay.value,
            headerVisible: false,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            //holidayPredicate: (day) {
            // Every 20th day of the month will be treated as a holiday
            //  return day.day == 20;
            //},
            onDaySelected: _onDaySelected,
            onCalendarCreated: (controller) => _pageController = controller,
            onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
            onFormatChanged: (format) {
              //if (_calendarFormat != format) {
              //   setState(() => _calendarFormat = format);
              //}
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
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
          // today button
          TextButton(
            onPressed: () => {
              developer.log('Goto Today', name: 'Goto Today'),
              _selectedDay = DateTime.now(),
              setState(() => _focusedDay.value = DateTime.now())
            },
            child: const Text('today'),
          ),
          // month/week display format button
          TextButton(
            onPressed: () => {
              developer.log('Month/Week', name: 'Month/Week'),
              setState(() {
                if (_calendarFormat == CalendarFormat.month) {
                  _calendarFormat = CalendarFormat.week;
                } else {
                  _calendarFormat = CalendarFormat.month;
                }
                _selectedEvents.value = [];
              })
            },
            child: Text(_calendarFormat.name),
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

// calendar widget
class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final VoidCallback onFormatButtonTap;
  final VoidCallback onAddEventTap;
  final bool clearButtonVisible;
  final CalendarFormat format;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
    required this.onFormatButtonTap,
    required this.onAddEventTap,
    required this.format,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);
    if (format == CalendarFormat.week)
      return Padding(padding: const EdgeInsets.symmetric(vertical: 8.0));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (format == CalendarFormat.month)
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: onLeftArrowTap,
            ),
          Spacer(), // use Spacer
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: TextStyle(fontSize: 26.0),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
