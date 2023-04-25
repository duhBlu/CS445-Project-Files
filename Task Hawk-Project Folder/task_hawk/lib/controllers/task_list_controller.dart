import 'package:get/get.dart';

import '../models/task.dart';
import '../models/task_list.dart';
import 'db/db_helper.dart';

/// The [TaskListController] class is responsible for managing task lists.
///
/// It extends the [GetxController] class to allow for reactive programming.
class TaskListController extends GetxController with GetxServiceMixin {
  @override
  void onReady() {
    super.onReady();
  }

  /// The list of [TaskList]s that this controller manages.
  var taskLists_List = <TaskList>[].obs;

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
    TaskList taskListInstance = TaskList(
      id: id,
      title: title,
      selected: selected,
      isPasswordProtected: isPasswordProtected,
      password: password,
      tasks: tasks,
    );
    //return await DBHelper.insertTaskList(taskList);
  }

  void isSelectedTaskList(TaskList taskListInstance) {
    DBHelper.updateTaskListSelection(taskListInstance);
    getTaskLists();
  }

  /// Gets all the [TaskList]s from the database and assigns them to [taskLists].
  void getTaskLists() async {
    List<Map<String, dynamic>> taskListsData = await DBHelper.queryTaskLists();
    taskLists_List.assignAll(
        taskListsData.map((data) => new TaskList.fromJson(data)).toList());
  }

  void deleteTaskList(TaskList taskList) {
    DBHelper.deleteTaskList(taskList);
    getTaskLists();
  }

  void toggleTaskListSelection(TaskList taskList) {
    taskList.selected = !taskList.selected;
    DBHelper.updateTaskListSelection(taskList);
    getTaskLists();
  }

  void setPasswordProtection(
      TaskList taskList, bool isPasswordProtected, String? password) {
    DBHelper.updatePasswordProtection(taskList, isPasswordProtected, password);
    getTaskLists();
  }
}
