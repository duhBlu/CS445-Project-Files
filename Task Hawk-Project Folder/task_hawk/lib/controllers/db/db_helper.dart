import 'package:sqflite/sqflite.dart';

import '../../models/task.dart';
import '../../models/task_list.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 5;
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
        onCreate: (db, version) async {
          print("Creating Task table");
          await db.execute(
            "CREATE TABLE $_taskTableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER, "
            "isShown INTEGER, "
            "taskListId INTEGER)",
          );

          print("Creating Task_List table");
          await db.execute(
            "CREATE TABLE IF NOT EXISTS $_taskListTableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, "
            "selected INTEGER, "
            "isPasswordProtected INTEGER, "
            "password STRING, "
            "canDelete INTEGER)",
          );
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          // Add your upgrade conditions here.
          // ...
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> resetDatabase() async {
    if (_db == null) {
      print('Database is not initialized');
      return;
    }

    try {
      // Drop existing tables
      await _db!.execute("DROP TABLE IF EXISTS $_taskTableName");
      await _db!.execute("DROP TABLE IF EXISTS $_taskListTableName");

      // Recreate tables
      await _db!.execute(
        "CREATE TABLE $_taskTableName("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title STRING, note TEXT, date STRING, "
        "startTime STRING, endTime STRING, "
        "remind INTEGER, repeat STRING, "
        "color INTEGER, "
        "isCompleted INTEGER, "
        "isShown INTEGER, "
        "taskListId INTEGER)",
      );

      await _db!.execute(
        "CREATE TABLE $_taskListTableName("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title STRING, "
        "selected INTEGER, "
        "isPasswordProtected INTEGER, "
        "password STRING, "
        "canDelete INTEGER)",
      );

      print("Tables reset successfully");
    } catch (e) {
      print("Error resetting tables: $e");
    }
  }
  //static Future<void> initDb() async {
  //  if (_db != null) {
  //    return;
  //  }
  //  try {
  //    String _path = await getDatabasesPath() + 'tasks.db';
  //    _db = await openDatabase(
  //      _path,
  //      version: _version,
  //      onCreate: (db, version) {
  //        print("Creating Task table");
  //        db.execute(
  //          "CREATE TABLE $_taskTableName("
  //          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
  //          "title STRING, note TEXT, date STRING, "
  //          "startTime STRING, endTime STRING, "
  //          "remind INTEGER, repeat STRING, "
  //          "color INTEGER, "
  //          "isCompleted INTEGER,)",
  //        );
  //      },
  //      onUpgrade: (db, oldVersion, newVersion) async {
  //        if (oldVersion < 5) {
  //          print("Creating Task_List table");
  //          await db.execute(
  //            "CREATE TABLE IF NOT EXISTS $_taskListTableName("
  //            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
  //            "title STRING, "
  //            "selected INTEGER, "
  //            "isPasswordProtected INTEGER, "
  //            "password STRING, "
  //            "tasks TEXT)",
  //          );
  //        }
  //        if (oldVersion < 5) {
  //          print("Adding canDelete column to Task_List table");
  //          await db.execute(
  //            "ALTER TABLE $_taskListTableName ADD COLUMN canDelete INTEGER",
  //          );
  //        }
  //      },
  //    );
  //  } catch (e) {
  //    print(e);
  //  }
  //}

  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_taskTableName, task!.toJson()) ?? 69;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("querry function called");
    return await _db!.query(_taskTableName);
  }

  static getTask(Task task) async {
    print("getTask function called");
    return await _db!
        .query(_taskTableName, where: 'id=?', whereArgs: [task.id]);
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

  static Future<int> updateTask(Task task) async {
    return await _db!.update(
      _taskTableName,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<void> updateTaskListId(int? taskId, int? taskListId) async {
    print("updateTaskListId function called");
    await _db!.rawUpdate('''
      UPDATE $_taskTableName
      SET taskListId = ?
      WHERE id = ?
    ''', [taskListId, taskId]);
  }

  static Future<int?> insertTaskList(TaskList? taskList) async {
    print("insert function called");
    return await _db?.insert(_taskListTableName, taskList!.toJson()) ?? 69;
  }

  static Future<List<Map<String, dynamic>>> queryTaskLists() async {
    print("querry function called");
    return await _db!.query(_taskListTableName);
  }

  static Future<void> deleteTaskList(TaskList taskList) async {
    print("delete function called");

    // Check if the task list can be deleted
    List<Map<String, dynamic>> result = await _db!.query(
      _taskListTableName,
      where: 'id=? AND canDelete=?',
      whereArgs: [taskList.id, 1],
    );

    // If the task list exists and can be deleted, proceed with the deletion
    if (result.isNotEmpty) {
      await _db!
          .delete(_taskListTableName, where: 'id=?', whereArgs: [taskList.id]);
    } else {
      print("Task list with ID ${taskList.id} cannot be deleted");
    }
  }

  static Future<void> updateTaskListSelection(TaskList taskList) async {
    print("update function called");
    await _db!.rawUpdate('''
    UPDATE $_taskListTableName
    SET selected = ?
    WHERE id = ?
  ''', [taskList.selected ? 1 : 0, taskList.id]);
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

  static Future<int> updateTaskList(TaskList taskList) async {
    return await _db!.update(
      _taskListTableName,
      taskList.toJson(),
      where: 'id = ?',
      whereArgs: [taskList.id],
    );
  }
}
