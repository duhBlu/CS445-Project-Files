import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_hawk/controllers/task_controller.dart';
import 'package:task_hawk/models/task.dart';
import 'package:task_hawk/services/notification_services.dart';
import 'package:task_hawk/ui/add_task_page.dart';
import 'package:task_hawk/ui/theme.dart';
import 'package:task_hawk/ui/widgets/add_task_button.dart';
import 'package:task_hawk/ui/widgets/task_tile.dart';
import '../services/theme_services.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'complex_example.dart';
import 'package:task_hawk/table_calendar.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:sliding_switch/sliding_switch.dart';
// for debugging
import 'dart:developer' as developer;

// hacky calendar utils
import 'package:task_hawk/calendar_src/shared/utils2.dart';

/// A page widget that displays a list of tasks and allows the user to add or delete tasks.
class HomePage extends StatefulWidget {
  /// Creates a new instance of [HomePage] with the given [key].
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_typing_uninitialized_variables
  final _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  var notifyHelper;

  /// Initializes the notification services and requests iOS permissions.
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
  CalendarFormat _calendarFormat = CalendarFormat.week;

  DateTime? _selectedDay;

  late PageController _pageController;

  /// Returns a list of [Event] objects for the given [day].
  List<Event> _getEventsForDay(DateTime day) {
    return (kEvents[day] ?? []) as List<Event>;
  }

  /// Handles the day selection event by updating the selected day and focused day.
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay.value = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  /// Builds the home page widget.
  ///
  /// This widget displays a list of tasks and a calendar view that allows the user
  /// to select and view tasks by date.
  ///
  /// Returns a [Scaffold] widget containing the page contents.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _addAppBar(), // custom app bar
      body: Column(
        children: [
          _addTaskBar(), // custom header bar

          //_addDateBar(), // custom widget that adds the sliding calendar

          // hiding datebar when in calendar mode
          if (_calendarFormat == CalendarFormat.week) (_addDateBar()),
          if (_calendarFormat == CalendarFormat.week) (_showTasks()),
          if (_calendarFormat == CalendarFormat.month) (_showCalendar()),

          // calendar junk
        ],
      ),
    );
  }

  /// Displays the list of tasks using an [Obx] widget that listens for changes in the
  /// task list and rebuilds the UI accordingly.
  ///
  /// Returns an [Expanded] widget containing the task list.
  _showTasks() {
    return Expanded(
      flex: 50,
      child: Obx(
        () {
          return ListView.builder(
            itemCount: _taskController.taskList.length,
            //itemCount: 9,
            itemBuilder: (_, index) {
              print(_taskController.taskList.length);
              Task task = _taskController.taskList[index];
              if (task.repeat == 'Daily') {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task,
                );
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task)),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (task.date == DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task)),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        color: Theme.of(context).colorScheme.background, //BACKGROUND COLOR
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.26
            : MediaQuery.of(context).size.height * 0.38,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground //The little notch at the top
                  ),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: "Task Completed",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    textColor: Theme.of(context).colorScheme.onBackground,
                    context: context,
                  ),
            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              textColor: Theme.of(context).colorScheme.onBackground,
              context: context,
            ),
            const SizedBox(height: 20),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              textColor: Theme.of(context).colorScheme.onBackground,
              isClose: true,
              context: context,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// Displays a bottom sheet with options to complete, delete, or close a task.
  ///
  /// The bottom sheet contains buttons for each option and displays different content
  /// based on whether the task is completed or not.
  ///
  /// [context] - The build context.
  /// [task] - The task to display options for.
  _bottomSheetButton({
    required String label,
    required Function() onTap,
    required Color textColor,
    required BuildContext context,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0,
            color: isClose == true
                ? Theme.of(context).colorScheme.onBackground
                : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true
              ? Colors.transparent
              : Theme.of(context).colorScheme.secondary,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose == true
                ? titleStyle.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)
                : titleStyle.copyWith(color: darkText),
          ),
        ),
      ),
    );
  }

  // custom function returns DatePicker widget within a Container
  _addDateBar() {
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
        selectionColor: Theme.of(context).colorScheme.secondary,
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
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  /// Returns a [Container] widget containing a custom [DatePicker] widget.
  ///
  /// The [DatePicker] widget displays a date picker with the current date selected by default.
  /// It allows users to select a date and updates the selected date when the user makes a selection.
  ///
  /// Returns a [Container] widget that displays the date picker with custom styles.

  _addTaskBar() {
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
                  style: subHeadingStyle.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Text(
                  "Upcoming",
                  style: headingStyle.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
          ),
          LiteRollingSwitch(
            value: true,
            width: 125,
            textOn: 'Weekly',
            textOff: 'Monthly',
            textOnColor: Colors.white,
            colorOn: Theme.of(context).colorScheme.secondary,
            colorOff: Theme.of(context).colorScheme.secondary,
            iconOn: Icons.view_week_outlined,
            iconOff: Icons.calendar_view_month_outlined,
            animationDuration: const Duration(milliseconds: 500),
            onChanged: (bool state) {
              print('Moved to ${(state) ? 'weekly view' : 'monthly view'}');
            },
            onTap: () {
              setState(
                () {
                  if (_calendarFormat == CalendarFormat.week) {
                    _calendarFormat = CalendarFormat.month;
                  } else if (_calendarFormat == CalendarFormat.month) {
                    _calendarFormat = CalendarFormat.week;
                  }
                },
              );
            },
            onDoubleTap: () {},
            onSwipe: () {},
          ),
          CreateTaskButton(
            onTap: () async {
              await Get.to(() => AddTaskPage());
              _taskController.getTasks();
            },
            // on tap, opens new page defined in /lib/ui/widgets/add_task_page.dart
          )
        ],
      ),
    );
  }

  /// Returns an [AppBar] widget with a dark/light mode button and a sample user avatar.
  ///
  /// The [AppBar] widget contains a [GestureDetector] that allows users to switch between
  /// dark and light mode.
  /// The [AppBar] widget also contains a user avatar to represent the current user.
  ///
  /// Returns an [AppBar] widget with a dark/light mode button and a sample user avatar.

  _addAppBar() {
    return AppBar(
      leading: GestureDetector(
        // refreshes the page state on tap, so pages react dynamically
        onTap: () {
          setState(() {
            ThemeService().switchTheme();
          });
          // initialize notifications, call NotifyHelper defined in /lib/services/notification_services.dart
          //NotifyHelper notifyHelper = NotifyHelper();
          //notifyHelper.displayNotification(
          //    title: "Theme Changed",
          //    body: Get.isDarkMode
          //        ? "Activated Light Theme"
          //        : "Activated Dark Theme");
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

  _showCalendar() {
    return Expanded(
      child: Column(
        children: [
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
      ),
    );
  }
}

/// A custom widget that displays a calendar header with navigation buttons.
///
/// The [_CalendarHeader] widget displays the month and year of the selected date
/// in a format of "MMM yyyy". It also provides buttons to navigate to the previous
/// and next month, go to today's date, clear the selected date, and switch between
/// month and week formats.
///
/// Required parameters:
/// * [focusedDay]: A [DateTime] object representing the currently focused day.
/// * [onLeftArrowTap]: A [VoidCallback] function that is called when the left arrow
///   button is pressed.
/// * [onRightArrowTap]: A [VoidCallback] function that is called when the right arrow
///   button is pressed.
/// * [onTodayButtonTap]: A [VoidCallback] function that is called when the "Today" button
///   is pressed.
/// * [onClearButtonTap]: A [VoidCallback] function that is called when the "Clear" button
///   is pressed.
/// * [onFormatButtonTap]: A [VoidCallback] function that is called when the "Month/Week"
///   button is pressed.
/// * [onAddEventTap]: A [VoidCallback] function that is called when the "Add Event" button
///   is pressed.
/// * [clearButtonVisible]: A boolean value that determines whether the "Clear" button should
///   be visible.
/// * [format]: A [CalendarFormat] enum value that determines the current format of the calendar.
///
/// Returns a [_CalendarHeader] widget that displays the month and year of the selected date
/// and provides buttons to navigate the calendar and switch between formats.

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
