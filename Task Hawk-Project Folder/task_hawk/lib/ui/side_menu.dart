import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_hawk/models/task_list.dart';
import 'package:task_hawk/ui/add_tasklist_page.dart';
import 'package:task_hawk/ui/theme.dart';
import 'package:task_hawk/ui/widgets/task_list_options_buttons.dart';
import 'package:task_hawk/ui/widgets/task_list_tile.dart';

import '../controllers/task_controller.dart';
import '../controllers/task_list_controller.dart';
import '../models/task.dart';
import 'edit_tasklist_page.dart';

class SideMenu extends StatefulWidget {
  SideMenu({Key? key}) : super(key: key);

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> with TickerProviderStateMixin {
  late AnimationController _controller;
  final _taskController = Get.find<TaskController>();
  final _taskListController = Get.find<TaskListController>();

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _taskListController.getTaskLists();
    if (_taskListController.tasklists_List.isEmpty) {
      /// Enable only if there are no task lists
      //initializeDefaultTaskList();
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

  /// Enable only if there are no task lists
  Future<void> initializeDefaultTaskList() async {
    for (int index = 0; index < _taskController.taskList.length; index++) {
      _taskController.getTasks();
      TaskList taskList = _taskListController.tasklists_List[0];
      Task task = _taskController.taskList[index];
      _taskController.updateTaskListID(task.id, taskList.id);
      _taskController.getTasks();
    }

    TaskList defaultTaskList = TaskList(
        id: 1,
        title: 'default',
        selected: true,
        isPasswordProtected: false,
        canDelete: false);
    int? value =
        await _taskListController.addTaskList(taskList: defaultTaskList);
    print("Task List: id = " + "$value");
  }

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
            child: Stack(
              children: [
                Column(
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
                              taskListController: _taskListController,
                              taskList:
                                  _taskListController.tasklists_List[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                CustomFloatingActionButton(
                  onPressedDelete: () async {
                    bool? result = await _taskListController
                        .showDeleteTaskListDialog(context);
                    if (result != null && result) {
                      _taskListController.getTaskLists();
                      _taskController.getTasks();
                    }
                  },
                  onPressedEdit: () async {
                    TaskList? selectedTaskList = await _taskListController
                        .showEditTaskListDialog(context);
                    if (selectedTaskList != null) {
                      await Get.to(() =>
                          EditTaskListPage(selectedTaskList: selectedTaskList));
                      _taskListController.getTaskLists();
                    }
                  },
                  onPressedCreate: () async {
                    // Handle the action of the third button
                    await Get.to(() => AddTaskListPage());
                    _taskListController.getTaskLists();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
