import 'package:sqflite/sqflite.dart';

import '../../models/task.dart';
import '../../models/task_list.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _taskTableName = "tasks";
  static final String _taskListTableName = "task_lists";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("creating a new one");
          return db.execute(
            "CREATE TABLE $_taskTableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER,"
            "taskListd INTEGER)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_taskTableName, task!.toJson()) ?? 69;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("querry function called");
    return await _db!.query(_taskTableName);
  }

  static delete(Task task) async {
    await _db!.delete(_taskTableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
    ''', [1, id]);
  }

  
  static Future<int> insertTaskList(TaskList? taskList) async {
    // TODO: Implement the insert logic for task lists
    return 0;
  }

  static Future<List<Map<String, dynamic>>> queryTaskLists() async {
    // TODO: Implement the query logic for task lists
    return [];
  }

  static Future<void> deleteTaskList(TaskList taskList) async {
    // TODO: Implement the delete logic for task lists
  }

  static Future<void> updateTaskListSelection(TaskList taskList) async {
    // TODO: Implement the update logic for task list selection
  }

  static Future<void> updatePasswordProtection(TaskList taskList, bool isPasswordProtected, String? password) async {
    // TODO: Implement the update logic for task list password protection
  }
}
