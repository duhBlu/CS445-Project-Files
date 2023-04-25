import 'package:sqflite/sqflite.dart';

import '../../models/task.dart';
import '../../models/task_list.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 2;
  static const String _taskTableName = "tasks";
  static const String _taskListTableName = "task_lists";

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
          print("Creating Task table");
          db.execute(
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
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            print("Creating Task_List table");
            await db.execute(
              "CREATE TABLE IF NOT EXISTS $_taskListTableName("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title STRING, "
              "selected INTEGER, "
              "isPasswordProtected INTEGER, "
              "password STRING, "
              "tasks TEXT)",
            );
          }
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
    print("insert function called");
    return await _db?.insert(_taskListTableName, taskList!.toJson()) ?? 69;
  }

  static Future<List<Map<String, dynamic>>> queryTaskLists() async {
    print("querry function called");
    return await _db!.query(_taskListTableName);
  }

  static Future<void> deleteTaskList(TaskList taskList) async {
    print("delete function called");
    await _db!
        .delete(_taskListTableName, where: 'id=?', whereArgs: [taskList.id]);
  }

  static Future<void> updateTaskListSelection(TaskList taskList) async {
    print("update function called");
    await _db!.update(
        _taskListTableName, {'selected': taskList.selected ? 1 : 0},
        where: 'id=?', whereArgs: [taskList.id]);
  }

  static Future<void> updatePasswordProtection(
      TaskList taskList, bool isPasswordProtected, String? password) async {
    print("update password function called");
    await _db!.update(
      _taskListTableName,
      {
        'isPasswordProtected': isPasswordProtected ? 1 : 0,
        'password': password,
      },
      where: 'id=?',
      whereArgs: [taskList.id],
    );
  }
}
