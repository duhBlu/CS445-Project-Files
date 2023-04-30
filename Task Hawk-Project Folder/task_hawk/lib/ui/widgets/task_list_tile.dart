import 'package:flutter/material.dart';
import 'package:task_hawk/controllers/task_list_controller.dart';
import 'package:task_hawk/models/task_list.dart';
import 'package:task_hawk/ui/theme.dart';

class TaskListTile extends StatefulWidget {
  final TaskList taskList;
  final TaskListController taskListController;

  const TaskListTile(
      {Key? key, required this.taskList, required this.taskListController})
      : super(key: key);

  @override
  _TaskListTileState createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  bool _selected = false;

  String capitalize(String text) {
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  void initState() {
    super.initState();
    _selected = widget.taskList.selected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _selected = !_selected;
        });
        widget.taskList.selected = _selected;
        widget.taskListController.toggleTaskListSelection(widget.taskList);
      },
      child: ListTile(
        leading: Checkbox(
          value: _selected,
          onChanged: null,
        ),
        title: Text(
          "${capitalize(widget.taskList.title)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
      ),
    );
  }
}
