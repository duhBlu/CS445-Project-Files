import 'package:flutter/material.dart';

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
            onPressed: onPressedFirst,
            child: Icon(Icons.delete_rounded),
          ),
        ),
        Positioned(
          right: 10 + 70 * 2,
          bottom: 15,
          child: FloatingActionButton(
            onPressed: onPressedSecond,
            child: Icon(Icons.edit_attributes_outlined),
          ),
        ),
        Positioned(
          right: 10 + 70 * 3,
          bottom: 15,
          child: FloatingActionButton(
            onPressed: onPressedThird,
            child: Icon(Icons.add_task),
          ),
        ),
      ],
    );
  }
}
