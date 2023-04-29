import 'dart:convert';

import 'task.dart';

/// A class representing a task list object with information about the list created by the user.
///
class TaskList {
  int? id;
  String title;
  bool selected;
  bool? isPasswordProtected;
  String? password;
  bool canDelete;

  /// Creates a new instance of the [TaskList] class.
  TaskList({
    this.id,
    required this.title,
    required this.selected,
    required this.isPasswordProtected,
    this.password,
    required this.canDelete,
  });

  /// Creates a new instance of the [TaskList] class from a JSON map.
  factory TaskList.fromJson(Map<String, dynamic> json) {
    /// Creates a new instance of the [TaskList] class from a JSON map.
    return TaskList(
      id: json['id'],
      title: json['title'],
      selected: json['selected'] == 1,
      isPasswordProtected: json['isPasswordProtected'] == 1,
      password: json['password'],
      canDelete: json['canDelete'] == 1,
    );
  }

  /// Returns a JSON representation of the [TaskList] instance.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'selected': selected,
      'isPasswordProtected': isPasswordProtected,
      'password': password,
      'canDelete': canDelete,
    };
  }
}
