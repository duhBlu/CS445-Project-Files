import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_hawk/models/task_list.dart';
import 'package:task_hawk/ui/theme.dart';
import 'package:task_hawk/ui/widgets/task_list_tile.dart';

import '../controllers/task_controller.dart';
import '../controllers/task_list_controller.dart';
import '../models/task.dart';

class SideMenu extends StatefulWidget {
  SideMenu({Key? key}) : super(key: key);

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> with TickerProviderStateMixin {
  late AnimationController _controller;
  final _taskController = Get.find<TaskController>();
  final _taskListController = Get.put(TaskListController());

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (_taskListController.tasklists_List.isEmpty) {
      initializeDefaultTaskList();
    }

    super.initState();
  }

  void toggleMenu() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Future<void> initializeDefaultTaskList() async {
    print(_taskListController.tasklists_List.length);
    if (_taskListController.tasklists_List.isEmpty) {
      List<Task> currentTasks = [];

      for (int index = 0; index < _taskController.taskList.length; index++) {
        Task task = _taskController.taskList[index];
        currentTasks.add(task);
        print(task.toString());
      }

      TaskList defaultTaskList = TaskList(
          id: 1,
          title: 'default',
          selected: true,
          isPasswordProtected: false,
          tasks: currentTasks);
      int value =
          await _taskListController.addTaskList(taskList: defaultTaskList);
      print("Task List: id = " + "$value");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        ).animate(_controller),
        child: Container(
          width: 288,
          height: double.infinity,
          color: appbarcolor,
          child: SafeArea(
            child: Column(
              children: [
                ListTile(
                  title: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Task List Manager",
                        style: headingStyle.copyWith(color: darkText),
                      ),
                    ),
                  ),
                  subtitle: const Center(
                    child: Text(
                      "Select Task Lists to be displayed",
                      style: TextStyle(color: darkText),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 24, top: 32, bottom: 16),
                  child: Text(
                    "Task Lists",
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: darkText),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: _taskListController.tasklists_List.length,
                      itemBuilder: (context, index) {
                        return TaskListTile(
                          taskList: _taskListController.tasklists_List[index],
                          onChanged: (bool? value) {
                            _taskListController.toggleTaskListSelection(
                                _taskListController.tasklists_List[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
