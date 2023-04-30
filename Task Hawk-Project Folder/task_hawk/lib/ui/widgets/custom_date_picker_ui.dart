import 'package:flutter/material.dart';
import 'package:task_hawk/ui/theme.dart';

class CustomDatePickerDialog extends DatePickerDialog {
  CustomDatePickerDialog({
    Key? key,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    SelectableDayPredicate? selectableDayPredicate,
    String? cancelText,
    String? confirmText,
    String? helpText,
    DatePickerMode initialCalendarMode = DatePickerMode.day,
    String? errorFormatText,
    String? errorInvalidText,
    String? fieldHintText,
    String? fieldLabelText,
    TextInputType? keyboardType,
  }) : super(
          key: key,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
          initialEntryMode: initialEntryMode,
          selectableDayPredicate: selectableDayPredicate,
          cancelText: cancelText,
          confirmText: confirmText,
          helpText: helpText,
          initialCalendarMode: initialCalendarMode,
          errorFormatText: errorFormatText,
          errorInvalidText: errorInvalidText,
          fieldHintText: fieldHintText,
          fieldLabelText: fieldLabelText,
          keyboardType: keyboardType,
        );

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: Theme.of(context)
              .colorScheme
              .secondary, // Header background color
          onPrimary: darkText, // Header text color
          onSurface: Theme.of(context).colorScheme.onBackground,
          surface: Theme.of(context).colorScheme.secondary,
          secondary:
              Theme.of(context).colorScheme.onBackground, // OK button color
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Theme.of(context)
                .colorScheme
                .onBackground, // Cancel button color
          ),
        ),
      ),
      child: DatePickerDialog(
        key: widget.key,
        initialDate: widget.initialDate,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        currentDate: widget.currentDate,
        initialEntryMode: widget.initialEntryMode,
        selectableDayPredicate: widget.selectableDayPredicate,
        cancelText: widget.cancelText,
        confirmText: widget.confirmText,
        helpText: widget.helpText,
        initialCalendarMode: widget.initialCalendarMode,
        errorFormatText: widget.errorFormatText,
        errorInvalidText: widget.errorInvalidText,
        fieldHintText: widget.fieldHintText,
        fieldLabelText: widget.fieldLabelText,
        keyboardType: widget.keyboardType,
      ),
    );
  }
}
