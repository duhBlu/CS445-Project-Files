import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_hawk/controllers/task_list_controller.dart';
import 'package:task_hawk/models/task.dart';
import 'package:task_hawk/models/task_list.dart';
import 'package:task_hawk/ui/theme.dart';
import 'package:task_hawk/ui/widgets/input_field.dart';

/// A StatefulWidget representing the Edit Task List page.
///
/// Takes a [selectedTaskList] as a required parameter.
/// Displays a form for the user to edit the selected task list's information.
class EditTaskListPage extends StatefulWidget {
  /// The task list to be edited.
  final TaskList selectedTaskList;
  /// Creates a new [EditTaskListPage] instance.
  ///
  /// [selectedTaskList] is a required parameter.
  const EditTaskListPage({Key? key, required this.selectedTaskList})
      : super(key: key);

  @override
  _EditTaskListPage createState() => _EditTaskListPage();
}

/// The private State class for [EditTaskListPage] StatefulWidget.
///
/// Implements the UI and logic for editing a task list.
class _EditTaskListPage extends State<EditTaskListPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TaskListController _taskListController = Get.find<TaskListController>();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  bool _passwordProtection = false;
  TaskList? _selectedTaskList;

  @override
  void initState() {
    super.initState();
    _selectedTaskList = widget.selectedTaskList;
    _titleController.text = _selectedTaskList?.title ?? "";
    _passwordController.text = _selectedTaskList?.password ?? "";
    _passwordProtection = _selectedTaskList?.password != null;
  }

  // Builds the UI of the Edit Task List page.
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
                "Edit Task List",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              TaskInputField(
                title: "Title",
                hint: "Enter title of task list",
                controller: _titleController,
              ),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text("Password protection\n [Not Implemented]"),
                value: _passwordProtection,
                onChanged: (bool value) {
                  setState(() {
                    _passwordProtection = value;
                  });
                },
              ),
              if (_passwordProtection) ...[
                TaskInputField(
                  title: "Password",
                  hint: "Enter your password",
                  controller: _passwordController,
                ),
                TaskInputField(
                  title: "Confirm Password",
                  hint: "Confirm your password",
                  controller: _passwordConfirmationController,
                ),
              ],
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => __validateData(),
                      child: Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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
  /// Creates an AppBar for the Edit Task List page.
  ///
  /// [context] is the [BuildContext] in which the AppBar is being built.
  /// Has back button to navigate to the previous page
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
  /// Validates the user input and updates the task list.
  ///
  /// Ensures that the title, password, and password confirmation are valid.
  /// Updates the task list in the [_taskListController] and navigates back 
  __validateData() {
    if (_titleController.text.isNotEmpty) {
      //add to database
      _updateTaskListToDb();
      Get.back();
    } else if (_titleController.text.isEmpty) {
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
  
  /// Updates the task list in the database.
  ///
  /// Sets the new values for the task list's title, password, and password protection status,
  /// and updates the task list in the [_taskListController].
  _updateTaskListToDb() async {
    _selectedTaskList!.title = _titleController.text;
    _selectedTaskList!.password = _passwordController.text;
    _selectedTaskList!.isPasswordProtected = _passwordProtection;
    _taskListController.updateTaskList(_selectedTaskList!);
  }
}
