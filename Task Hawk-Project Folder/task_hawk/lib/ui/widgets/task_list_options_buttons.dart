import 'package:flutter/material.dart';
import 'package:task_hawk/ui/theme.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressedFirst;
  final VoidCallback? onPressedSecond;
  final VoidCallback? onPressedThird;

  CustomFloatingActionButton({
    this.onPressedFirst,
    this.onPressedSecond,
    this.onPressedThird,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Positioned(
          right: 10 + 70,
          bottom: 15,
          child: FloatingActionButton(
            heroTag: "trashBtn",
            onPressed: onPressedFirst,
            child: Icon(
              Icons.delete_rounded,
              color: darkText,
            ),
          ),
        ),
        Positioned(
          right: 10 + 70 * 2,
          bottom: 15,
          child: FloatingActionButton(
            heroTag: "editBtn",
            onPressed: onPressedSecond,
            child: Icon(
              Icons.edit_attributes_outlined,
              color: darkText,
            ),
          ),
        ),
        Positioned(
          right: 10 + 70 * 3,
          bottom: 15,
          child: FloatingActionButton(
            heroTag: "createBtn",
            onPressed: onPressedThird,
            child: Icon(
              Icons.add_task,
              color: darkText,
            ),
          ),
        ),
      ],
    );
  }
}
