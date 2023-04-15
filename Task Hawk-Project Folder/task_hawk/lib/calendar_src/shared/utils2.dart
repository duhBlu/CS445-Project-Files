
// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:io';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    // load and save from file

    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('5:00 am     Wake Up.'),
      Event('2:00 pm     Sell blood for eggs.'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

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
