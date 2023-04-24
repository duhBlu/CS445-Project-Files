// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:io';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:task_hawk/models/task.dart';
import 'package:flutter/material.dart';

/// Example event class.
class Event {
  final Task task; // Add a Task field
  // Add a constructor that takes a Task object as an argument
  Event.fromTask({required this.task});
  const Event(this.task);
}

/// Example events.
///

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

//import 'dart:async' show Future;
//import 'package:flutter/services.dart' show rootBundle;
/*
void main() async {
  // Read the events file and store the events in a LinkedHashMap
  //final eventsFile = await File('images/test.txt').readAsString();
  //final Directory directory = await getApplicationDocumentsDirectory();
  //  final File file = File('${directory.path}/my_file.txt');

  final String path = rootBundle.loadString('images/test.txt') as String;
  final eventsFile = await File('${path}/test.txt').readAsString();
  final eventsList = LineSplitter().convert(eventsFile);
  final eventsMap = LinkedHashMap<DateTime, String>.fromIterable(
    eventsList,
    key: (item) => DateTime.parse(item.split('|')[0]),
    value: (item) => item.split('|')[1],
  );

  // Ask the user to select a date and parse it as a DateTime
  final selectedDate = DateTime.parse('2022-03-17');

  // Check if there's an event on the selected date
  if (eventsMap.containsKey(selectedDate)) {
    print(
        'There\'s an event on ${selectedDate.toString().split(' ')[0]}: ${eventsMap[selectedDate]}');
  } else {
    print('There are no events on ${selectedDate.toString().split(' ')[0]}');
  }
}*/
