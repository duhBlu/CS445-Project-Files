import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/task.dart';
import '../models/task_list.dart';
import 'db/db_helper.dart';

/// The [TaskListController] class is responsible for managing task lists.
///
/// It extends the [GetxController] class to allow for reactive programming.
class TaskListController extends GetxController with GetxServiceMixin {
  var taskListDeleted = false.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
  }

  /// The list of [TaskList]s that this controller manages.
  var tasklists_List = <TaskList>[].obs;

  /// Adds a new [TaskList] to the database.
  ///
  /// Returns the ID of the inserted [TaskList] as an [int].
  Future<int?> addTaskList({TaskList? taskList}) async {
    print("insert function called");
    int? id = await DBHelper.insertTaskList(taskList);
    getTaskLists();
    return id;
  }

  void isSelectedTaskList(TaskList taskListInstance) {
    DBHelper.updateTaskListSelection(taskListInstance);
    getTaskLists();
  }

  /// Gets all the [TaskList]s from the database and assigns them to [taskLists].
  void getTaskLists() async {
    List<Map<String, dynamic>> taskListsData = await DBHelper.queryTaskLists();
    tasklists_List.assignAll(
        taskListsData.map((data) => new TaskList.fromJson(data)).toList());
  }

  void deleteTaskList(TaskList taskList) async {
    print("delete function called");
    await DBHelper.deleteTaskList(taskList);
    taskListDeleted.value = true;
  }

  void toggleTaskListSelection(TaskList taskList) {
    DBHelper.updateTaskListSelection(taskList);
    getTaskLists();
  }

  void setPasswordProtection(
      TaskList taskList, bool isPasswordProtected, String? password) {
    DBHelper.updatePasswordProtection(taskList, isPasswordProtected, password);
    getTaskLists();
  }

  Future<void> updateTaskList(TaskList taskList) async {
    await DBHelper.updateTaskList(taskList);
    getTaskLists();
  }

  Future<bool?> showDeleteTaskListDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Task List to Delete'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tasklists_List.length,
              itemBuilder: (BuildContext context, int index) {
                TaskList taskList = tasklists_List[index];
                return ListTile(
                  title: Text(taskList.title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteTaskList(taskList);
                      taskListDeleted.value =
                          false; // Reset taskListDeleted to false
                      Get.back(); // Close the dialog and return true
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Get.back(result: false), // Close the dialog and return false
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
          ],
        );
      },
    );
  }
}
