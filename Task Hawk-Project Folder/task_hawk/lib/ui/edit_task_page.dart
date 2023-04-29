import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:task_hawk/controllers/task_controller.dart';
import 'package:task_hawk/controllers/task_list_controller.dart';
import 'package:task_hawk/models/task.dart';
import 'package:task_hawk/ui/theme.dart';
import 'package:task_hawk/ui/widgets/add_task_button.dart';
import 'package:task_hawk/ui/widgets/input_field.dart';
import '../models/task_list.dart';
import '../services/notification_services.dart';
import '../services/theme_services.dart';

/// A page for editing an existing task.

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskPage();
}

/// The private state class for the AddTaskPage.
class _EditTaskPage extends State<EditTaskPage> {
  /// Initialize the text field controllers, for data storage/update/n'stuff
  final TaskController _taskController = Get.put(TaskController());
  final TaskListController _taskListController = Get.find<TaskListController>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  TaskList? _selectedTaskList;
  Task? _selectedTask;
  @override
  void initState() {
    super.initState();
    if (_taskListController.tasklists_List.isNotEmpty) {
      _selectedTaskList = _taskListController.tasklists_List.first;
    }

    //if (_taskController.selectedTask) {
    _selectedTask = _taskController.selectedTask!;
    _titleController.text = _selectedTask?.title ?? "";
    _noteController.text = _selectedTask?.note ?? "";
    _selectedDate = DateFormat('MM/dd/yy').parse(_selectedTask?.date ?? "");
//    DateTime.parse(_selectedTask?.date ?? DateTime.now().toString());
    _endTime = _selectedTask?.endTime ?? "9:30 PM";
    _startTime = _selectedTask?.startTime ??
        DateFormat("hh:mm a").format(DateTime.now()).toString();
    _selectedRemind = _selectedTask?.remind ?? 5;
    _selectedRepeat = _selectedTask?.repeat ?? "None";
    _selectedColor = _selectedTask?.color ?? 0;
    _selectedTaskList =
        _taskListController.tasklists_List[_selectedTask?.taskListID ?? 0];
    //}
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

  /// Builds the EditTaskPage widget.
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
                "Change Task",
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
                    color: Get.isDarkMode ? lightText : darkText,
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
                    setState(() {
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
              TaskInputField(
                title: "Repeat",
                hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Get.isDarkMode ? lightText : darkText,
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
                    color: Get.isDarkMode ? lightText : darkText,
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
                    color: Get.isDarkMode ? lightText : darkText,
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
      __updateTaskToDb();
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

  /// updates task in the database.
  __updateTaskToDb() async {
    _selectedTask?.note = _noteController.text;
    _selectedTask?.title = _titleController.text;
    _selectedTask?.date = DateFormat.yMd().format(_selectedDate);
    _selectedTask?.startTime = _startTime;
    _selectedTask?.endTime = _endTime;
    _selectedTask?.remind = _selectedRemind;
    _selectedTask?.repeat = _selectedRepeat;
    _selectedTask?.color = _selectedColor;
    _selectedTask?.isCompleted = 0;
    _selectedTask?.taskListID = _selectedTaskList!.id;

    _taskController.updateTask(_selectedTask!);
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
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {}
  }

  /// Displays a time picker dialog to allow the user to select a start or end time for the task.
  __getTimefromUser({required bool isStartTime}) async {
    var pickedTime = await __showTimePicker();
    String _formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time Canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  /// Shows a time picker dialog for selecting a time.
  __showTimePicker() {
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
            dialogBackgroundColor: Theme.of(context).colorScheme.background,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context)
                  .colorScheme
                  .secondary, // Modify this to change the primary color
              onPrimary: Theme.of(context).colorScheme.background,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(
                  color: Colors
                      .black), // Modify this to change the text color of time picker
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
