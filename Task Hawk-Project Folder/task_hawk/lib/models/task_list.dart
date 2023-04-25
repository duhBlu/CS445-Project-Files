import 'dart:convert';

import 'task.dart';

/// A class representing a task list object with information about the list created by the user.
///
class TaskList {
  int id;
  String title;
  bool selected;
  bool isPasswordProtected;
  String? password;
  List<Task> tasks;

  /// Creates a new instance of the [TaskList] class.
  TaskList({
    required this.id,
    required this.title,
    required this.selected,
    required this.isPasswordProtected,
    this.password,
    required this.tasks,
  });

  /// Creates a new instance of the [TaskList] class from a JSON map.
  factory TaskList.fromJson(Map<String, dynamic> json) {
    List<dynamic> taskJsonList = json['tasks'];
    List<Task> taskList =
        taskJsonList.map((task) => Task.fromJson(task)).toList();

    /// Creates a new instance of the [TaskList] class from a JSON map.
    return TaskList(
      id: json['id'],
      title: json['title'],
      selected: json['selected'],
      isPasswordProtected: json['isPasswordProtected'],
      password: json['password'],
      tasks: (jsonDecode(json['tasks']) as List)
          .map((taskJson) => Task.fromJson(taskJson))
          .toList(),
    );
  }

  /// Returns a JSON representation of the [TaskList] instance.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'selected': selected,
      'isPasswordProtected': isPasswordProtected,
      'password': password,
      'tasks': json.encode(tasks.map((task) => task.toJson()).toList()),
    };
  }
}
