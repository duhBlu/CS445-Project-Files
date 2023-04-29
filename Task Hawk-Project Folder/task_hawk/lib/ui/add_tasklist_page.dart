import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_hawk/controllers/task_list_controller.dart';
import 'package:task_hawk/models/task.dart';
import 'package:task_hawk/models/task_list.dart';
import 'package:task_hawk/ui/theme.dart';
import 'package:task_hawk/ui/widgets/input_field.dart';

class AddTaskListPage extends StatefulWidget {
  const AddTaskListPage({Key? key}) : super(key: key);

  @override
  _AddTaskListPageState createState() => _AddTaskListPageState();
}

class _AddTaskListPageState extends State<AddTaskListPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TaskListController _taskListController = Get.find<TaskListController>();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  bool _passwordProtection = false;

  @override
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
                "New Task List",
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

  __validateData() {
    if (_titleController.text.isNotEmpty &&
        _titleController.text != 'default') {
      //add to database
      _addTaskListToDb();
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

  _addTaskListToDb() async {
    List<Task> tasks = [];
    int? value = await _taskListController.addTaskList(
        taskList: TaskList(
            title: _titleController.text,
            selected: true,
            isPasswordProtected: false,
            canDelete: true));
    print("task list $value was created");
  }
}
