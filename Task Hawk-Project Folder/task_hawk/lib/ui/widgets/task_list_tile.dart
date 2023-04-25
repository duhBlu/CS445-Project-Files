import 'package:flutter/material.dart';
import 'package:task_hawk/models/task_list.dart';

class TaskListTile extends StatelessWidget {
  final TaskList taskList;
  final ValueChanged<bool?> onChanged;

  TaskListTile({required this.taskList, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: taskList.selected,
        onChanged: onChanged,
      ),
      title: Text(
        taskList.title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
