import 'package:get/get.dart';

import '../models/task.dart';
import '../models/task_list.dart';
import 'db/db_helper.dart';

/// The [TaskListController] class is responsible for managing task lists.
///
/// It extends the [GetxController] class to allow for reactive programming.
class TaskListController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  /// The list of [TaskList]s that this controller manages.
  var taskLists = <TaskList>[].obs;

  /// Adds a new [TaskList] to the database.
  ///
  /// Returns the ID of the inserted [TaskList] as an [int].
  Future<int?> addTaskList({
    required int id,
    required String title,
    required bool selected,
    required bool isPasswordProtected,
    String? password,
    required List<Task> tasks,
  }) async {
    TaskList taskList = TaskList(
      id: id,
      title: title,
      selected: selected,
      isPasswordProtected: isPasswordProtected,
      password: password,
      tasks: tasks,
    );
    //return await DBHelper.insertTaskList(taskList);
  }
  /// Gets all the [TaskList]s from the database and assigns them to [taskLists].
  void getTaskLists() async {
    List<Map<String, dynamic>> taskListsData = await DBHelper.queryTaskLists();
    taskLists.assignAll(
        taskListsData.map((data) => new TaskList.fromJson(data)).toList());
  }
  /// Deletes a [TaskList] from the database.
  void deleteTaskList(TaskList taskList) {
    DBHelper.deleteTaskList(taskList);
    getTaskLists();
  }
  /// Toggles the [selected] attribute of a [TaskList].
  void toggleTaskListSelection(TaskList taskList) {
    DBHelper.updateTaskListSelection(taskList);
    getTaskLists();
  }
  /// Sets the [isPasswordProtected] and [password] attributes of a [TaskList].
  void setPasswordProtection(
      TaskList taskList, bool isPasswordProtected, String? password) {
    DBHelper.updatePasswordProtection(taskList, isPasswordProtected, password);
    getTaskLists();
  }
}
