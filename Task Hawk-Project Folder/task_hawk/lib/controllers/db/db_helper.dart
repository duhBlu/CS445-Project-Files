import 'package:sqflite/sqflite.dart';

import '../../models/task.dart';
import '../../models/task_list.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 5;
  static const String _taskTableName = "tasks";
  static const String _taskListTableName = "task_lists";

  /// Initializes the database by creating [_taskTableName] and [_taskListTableName] tables.
  /// If the database is already initialized, it returns immediately.
  /// It creates the tables with the specified columns and data types.
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

  /// Resets the database by dropping and recreating [_taskTableName] and [_taskListTableName] tables.
  /// It first drops the existing tables and then recreates them with the same schema.
  /// This function is useful for resetting the database to its initial state.
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

  /// Inserts a [Task] into the [_taskTableName] table.
  /// It takes a [Task] object, converts it to a JSON format, and inserts it into the database.
  /// Returns the generated primary key value for the inserted row.
  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_taskTableName, task!.toJson()) ?? 2345678;
  }

  /// Queries all rows from the [_taskTableName] table.
  /// It retrieves all the records in the table and returns them as a list of maps.
  /// Each map represents a row with column names as keys and column values
  static Future<List<Map<String, dynamic>>> query() async {
    print("querry function called");
    return await _db!.query(_taskTableName);
  }

  /// Retrieves a single [Task] from the [_taskTableName] table using the task's [id].
  /// Returns the task as a map with column names as keys and column values as map values.
  static getTask(Task task) async {
    print("getTask function called");
    return await _db!
        .query(_taskTableName, where: 'id=?', whereArgs: [task.id]);
  }

  /// Deletes a [Task] from the [_taskTableName] table using the task's [id].
  static delete(Task task) async {
    await _db!.delete(_taskTableName, where: 'id=?', whereArgs: [task.id]);
  }

  /// Updates the [isCompleted] field of a task in the [_taskTableName] table.
  /// Takes the [id] of the task and sets [isCompleted] to 1.
  static update(int id) async {
    return await _db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
    ''', [1, id]);
  }

  /// Updates a [Task] in the [_taskTableName] table.
  /// Takes a [Task] object, converts it to a JSON format, and updates the corresponding row in the database.
  /// Returns the number of rows affected by the update.
  static Future<int> updateTask(Task task) async {
    return await _db!.update(
      _taskTableName,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// Updates the [taskListId] field of a task in the [_taskTableName] table.
  /// Takes the [taskId] and the [taskListId] to update the task's associated task list.
  static Future<void> updateTaskListId(int? taskId, int? taskListId) async {
    print("updateTaskListId function called");
    await _db!.rawUpdate('''
      UPDATE $_taskTableName
      SET taskListId = ?
      WHERE id = ?
    ''', [taskListId, taskId]);
  }

  /// Inserts a [TaskList] into the [_taskListTableName] table.
  /// It takes a [TaskList] object, converts it to a JSON format, and inserts it into the database.
  /// Returns the generated primary key value for the inserted row.
  static Future<int?> insertTaskList(TaskList? taskList) async {
    print("insert function called");
    return await _db?.insert(_taskListTableName, taskList!.toJson()) ?? 69;
  }

  /// Queries all rows from the [_taskListTableName] table.
  /// It retrieves all the records in the table and returns them as a list of maps.
  /// Each map represents a row with column names as keys and column values as map values.
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

  /// Updates the [selected] field of a [TaskList] in the [_taskListTableName] table.
  /// Takes a [TaskList] object and updates the [selected] field in the corresponding row in the database.
  static Future<void> updateTaskListSelection(TaskList taskList) async {
    print("update function called");
    await _db!.rawUpdate('''
    UPDATE $_taskListTableName
    SET selected = ?
    WHERE id = ?
  ''', [taskList.selected ? 1 : 0, taskList.id]);
  }

  /// Updates the password protection of a [TaskList] in the [_taskListTableName] table.
  /// Takes a [TaskList] object, a [bool] value indicating whether the task list should be password protected,
  /// and a [String] representing the password if the task list is password protected.
  /// It updates the [isPasswordProtected] and [password] fields in the corresponding row in the database.-
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

  /// Updates a [TaskList] in the [_taskListTableName] table.
  /// Takes a [TaskList] object, converts it to a JSON format, and updates the corresponding row in the database.
  /// Returns the number of rows affected by the update.
  static Future<int> updateTaskList(TaskList taskList) async {
    return await _db!.update(
      _taskListTableName,
      taskList.toJson(),
      where: 'id = ?',
      whereArgs: [taskList.id],
    );
  }
}
