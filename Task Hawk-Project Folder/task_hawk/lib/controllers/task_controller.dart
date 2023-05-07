import 'package:get/get.dart';

import '../models/task.dart';
import 'db/db_helper.dart';

/// A [GetxController] that manages tasks.
class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  /// A list of tasks, wrapped in an [RxList] for observability.
  /// This enables auto-updating of UI when the list changes.
  var taskList = <Task>[].obs;

  /// var to hold selected task through diffrent pages
  var selectedTask;

  /// Adds a task to the database and returns its ID.
  /// Takes an optional [Task] object as an argument.
  /// Calls [DBHelper.insert] method to insert the task into the database.
  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  /// Fetches all tasks from the database and updates [taskList].
  /// Calls [DBHelper.query] method to fetch tasks from the database.
  /// Maps the fetched data to [Task] objects and assigns them to [taskList].
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  /// Deletes a task from the database and updates [taskList].
  /// Takes a [Task] object as an argument.
  /// Calls [DBHelper.delete] method to delete the task from the database.
  /// Updates the [taskList] by calling [getTasks] method.
  void delete(Task task) {
    DBHelper.delete(task);
    getTasks();
  }

  /// Marks a task as completed in the database and updates [taskList].
  /// Takes an [int] id representing the task's ID.
  /// Calls [DBHelper.update] method to update the task's completion status in the database.
  /// Updates the [taskList] by calling [getTasks] method.
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
  
  /// Updates a task in the database and updates [taskList].
  /// Takes a [Task] object as an argument.
  /// Calls [DBHelper.updateTask] method to update the task in the database.
  /// Updates the [taskList] by calling [getTasks] method.
  Future<void> updateTask(Task task) async {
    await DBHelper.updateTask(task);
    getTasks();
  }

  Future<void> updateTaskListID(int? taskId, int? taskListId) async {
    await DBHelper.updateTaskListId(taskId, taskListId);
    getTasks();
  }
}
