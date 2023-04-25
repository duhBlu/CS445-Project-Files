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
  var taskList = <Task>[].obs;

  /// Adds a task to the database and returns its ID.
  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  /// Fetches all tasks from the database and updates [taskList].
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  /// Deletes a task from the database and updates [taskList].
  void delete(Task task) {
    DBHelper.delete(task);
    getTasks();
  }

  /// Marks a task as completed in the database and updates [taskList].
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }

  
}
