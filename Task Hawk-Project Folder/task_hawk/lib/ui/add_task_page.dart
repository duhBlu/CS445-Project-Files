import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_hawk/controllers/task_controller.dart';
import 'package:task_hawk/controllers/task_list_controller.dart';
import 'package:task_hawk/models/task.dart';
import 'package:task_hawk/ui/theme.dart';
import 'package:task_hawk/ui/widgets/add_task_button.dart';
import 'package:task_hawk/ui/widgets/custom_date_picker_ui.dart';
import 'package:task_hawk/ui/widgets/input_field.dart';
import '../models/task_list.dart';
import '../services/notification_services.dart';
import '../services/theme_services.dart';

/// A page for adding a new task to the app.
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

/// The private state class for the AddTaskPage.
class _AddTaskPageState extends State<AddTaskPage> {
  /// Initialize the text field controllers, for data storage/update/n'stuff
  final TaskController _taskController = Get.put(TaskController());
  final TaskListController _taskListController = Get.find<TaskListController>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  TaskList? _selectedTaskList;
  @override
  void initState() {
    super.initState();
    if (_taskListController.tasklists_List.isNotEmpty) {
      _selectedTaskList = _taskListController.tasklists_List.first;
    }
  }

  // initialize private variables
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  // initial list of reminder options
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  String _selectedRepeat = "None";
  // initial list of repetition options
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  int _selectedColor = 0;

  /// Builds the AddTaskPage widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: __addAppBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Task",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              TaskInputField(
                title: "Title",
                hint: "Enter title of task",
                controller: _titleController,
              ),
              TaskInputField(
                title: "Note",
                hint: "Enter details of task",
                controller: _noteController,
              ),
              TaskInputField(
                title: "Task List",
                hint: _selectedTaskList!.title,
                widget: DropdownButton<TaskList>(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  underline: Container(height: 0),
                  iconSize: 30,
                  elevation: 4,
                  items: _taskListController.tasklists_List
                      .map<DropdownMenuItem<TaskList>>((TaskList value) {
                    return DropdownMenuItem<TaskList>(
                      value: value,
                      child: Text(
                        value.title!,
                      ),
                    );
                  }).toList(),
                  onChanged: (TaskList? newValue) {
                    print(_selectedTaskList!.id.toString());
                    setState(() {
                      ;
                      _selectedTaskList = newValue;
                    });
                  },
                ),
              ),
              TaskInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    __getDatefromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TaskInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          __getTimefromUser(isStartTime: true);
                        },
                        icon: const Icon(Icons.access_time_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TaskInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          __getTimefromUser(isStartTime: false);
                        },
                        icon: const Icon(Icons.access_time_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              TaskInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  underline: Container(height: 0),
                  iconSize: 30,
                  elevation: 4,
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                        value: value.toString(), child: Text(value.toString()));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                ),
              ),
              TaskInputField(
                title: "Repeat",
                hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  underline: Container(height: 0),
                  iconSize: 30,
                  elevation: 4,
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value!,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(),
                    CreateTaskButton(
                      onTap: () => __validateData(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Validates the input data and adds the task to the database if both the title and note fields are not empty.
  __validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      //add to database
      __addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:
            Get.isDarkMode ? const Color.fromARGB(255, 39, 39, 39) : lightText,
        icon: const Icon(Icons.warning),
      );
    }
  }

  /// Adds the new task to the database.
  __addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
        taskListID: _selectedTaskList!.id,
      ),
    );
    print("My id is $value\n");
  }

  /// Returns a column containing a color palette for the user to select the task color.
  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Color",
        ),
        Wrap(
          children: List<Widget>.generate(customColors.length, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0, top: 5),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: customColors[index],
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  /// Displays a date picker dialog to allow the user to select a date for the task.
  __getDatefromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2123),
      builder: (BuildContext context, Widget? child) {
        return CustomDatePickerDialog(
          initialDate: DateTime.now(),
          firstDate: DateTime(2015),
          lastDate: DateTime(2123),
          currentDate: DateTime.now(),
          initialEntryMode: DatePickerEntryMode.calendar,
          helpText: 'Select a date',
          cancelText: 'Cancel',
          confirmText: 'OK',
        );
      },
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  __getTimefromUser({required bool isStartTime}) async {
    var pickedTime = await __showTimePicker();

    if (pickedTime == null) {
      print("Time Canceled");
    } else {
      String formattedTime = pickedTime.format(context);
      if (isStartTime == true) {
        setState(() {
          _startTime = formattedTime;
        });
      } else if (isStartTime == false) {
        setState(() {
          _endTime = formattedTime;
        });
      }
    }
  }


  __showTimePicker() {
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context)
                  .colorScheme
                  .secondary, // Modify this to change the primary color
              onPrimary: Theme.of(context)
                  .colorScheme
                  .secondary, // Modify this to change the text color on primary color
              surface: Theme.of(context)
                  .colorScheme
                  .background, // Set the surface color to the current context's background color
            ),
            dialogBackgroundColor:
                backgroundColor, // Set the dialog background color to the current context's background color
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground), // Modify this to change the text color of time picker
            ),
          ),
          child: child!,
        );
      },
    );
  }

  /// Builds and returns the app bar for the task input screen.
  ///
  /// The app bar contains a back button and an app icon.
  __addAppBar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 20,
          color: Colors.white,
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
