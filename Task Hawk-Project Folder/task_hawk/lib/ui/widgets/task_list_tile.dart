import 'package:flutter/material.dart';
import 'package:task_hawk/controllers/task_list_controller.dart';
import 'package:task_hawk/models/task_list.dart';

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

  @override
  void initState() {
    super.initState();
    _selected = widget.taskList.selected;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: _selected,
        onChanged: (bool? value) {
          if (value != null) {
            setState(() {
              _selected = value;
            });
            widget.taskList.selected = _selected;
            widget.taskListController.toggleTaskListSelection(widget.taskList);
          }
        },
      ),
      title: Text(
        "${widget.taskList.id} ${widget.taskList.title} | Count: ${widget.taskListController.tasklists_List.length}",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
