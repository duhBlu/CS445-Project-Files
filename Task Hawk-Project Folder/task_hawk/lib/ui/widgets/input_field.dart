import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_hawk/ui/theme.dart';

// defines input field class
class TaskInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  // constructor for the text input fields in the create task page
  const TaskInputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget});

  // definition of style/format of the text input fields
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(),
          ),
          Container(
              height: 52,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: widget == null ? false : true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        hintText: hint,
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.none,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                      autofocus: false,
                      cursorColor: Get.isDarkMode ? color1 : color2,
                      controller: controller,
                    ),
                  ),
                  widget == null
                      ? Container()
                      : Container(
                          child: widget,
                        )
                ],
              ))
        ],
      ),
    );
  }
}
