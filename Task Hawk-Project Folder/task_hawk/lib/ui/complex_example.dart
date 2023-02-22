import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'dart:developer' as developer;

class TableComplexExample extends StatefulWidget {
  @override
  _TableComplexExampleState createState() => _TableComplexExampleState();
}

class Event {
  final String title;
  final DateTime date;

  Event(this.title, this.date);
}

class _TableComplexExampleState extends State<TableComplexExample> {
  List<Event> events = [
    Event('Event 1', DateTime.now()),
    Event('Event 2', DateTime.now()),
    Event('Event 3', DateTime.now()),
  ];
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  DateTime? _selectedDay;

  late PageController _pageController;

  get kEvents => null;

  get kFirstDay => DateTime(1, 1, 2000);

  get kLastDay => DateTime(30, 31, 2050);

  @override
  void initState() {
    super.initState();

    //_selectedDays.add(_focusedDay.value);
    _selectedDay = _focusedDay.value;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
  }

  @override
  void dispose() {
    // _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  bool get canClearSelection => _selectedEvents.value.isNotEmpty;

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay.value = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Hawk'),
      ),
      body: Column(
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: _focusedDay,
            builder: (context, DateTime value, _) {
              return _CalendarHeader(
                focusedDay: value,
                clearButtonVisible: canClearSelection,
                format: _calendarFormat,
                onTodayButtonTap: () {
                  developer.log('Goto Today', name: 'Goto Today');
                  _selectedDay = DateTime.now();
                  setState(() => _focusedDay.value = DateTime.now());
                },
                onAddEventTap: () {
                  developer.log('Add Event', name: 'Add Event');
                },
                onClearButtonTap: () {
                  developer.log('Remove Event', name: 'Remove Event');
                },
                onLeftArrowTap: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                onRightArrowTap: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                onFormatButtonTap: () {
                  if (_calendarFormat == CalendarFormat.month) {
                    _calendarFormat = CalendarFormat.week;
                  } else {
                    _calendarFormat = CalendarFormat.month;
                  }

                  setState(() {
                    _selectedEvents.value = [];
                  });
                },
              );
            },
          ),
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay.value,
            headerVisible: false,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            //eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            holidayPredicate: (day) {
              // Every 20th day of the month will be treated as a holiday
              return day.day == 20;
            },
            //onDaySelected: _onDaySelected,
            onCalendarCreated: (controller) => _pageController = controller,
            onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
            onFormatChanged: (format) {
              //if (_calendarFormat != format) {
              //   setState(() => _calendarFormat = format);
              //}
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final VoidCallback onFormatButtonTap;
  final VoidCallback onAddEventTap;
  final bool clearButtonVisible;
  final CalendarFormat format;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
    required this.onFormatButtonTap,
    required this.onAddEventTap,
    required this.format,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: TextStyle(fontSize: 26.0),
            ),
          ),
          TextButton(
            onPressed: onTodayButtonTap,
            child: Text('today'),
          ),
          if (clearButtonVisible)
            IconButton(
              icon: Icon(Icons.add, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onAddEventTap,
            ),
          const Spacer(),
          TextButton(
            onPressed: onFormatButtonTap,
            child: Text(format.name),
          ),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
