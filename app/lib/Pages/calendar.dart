import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};

  void addEvent(String title, DateTime deadline) {
    setState(() {
      if (_events[deadline] == null) {
        _events[deadline] = [];
      }
      _events[deadline]!.add(Event(title: title, deadline: deadline));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Event>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          
          eventLoader: (day) {
            return _events[day] ?? [];
          },
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary, // Format button background color
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor, // Color for today
              shape: BoxShape.circle,
            ),
            defaultTextStyle: TextStyle(
              color: Colors.black, // Default text color
            ),
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(
              color: Colors.black, // Header title text color
              fontSize: 20.0,
            ),
           
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: Colors.black, // Left chevron icon color
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: Colors.black, // Right chevron icon color
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: _getEventsForDay(_selectedDay ?? _focusedDay),
          ),
        ),
      ],
    );
  }

  List<Widget> _getEventsForDay(DateTime day) {
    return _events[day]
            ?.map((event) => ListTile(
                  title: Text(event.title),
                  subtitle:
                      Text(DateFormat('MMM dd, yyyy').format(event.deadline)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteEvent(event),
                  ),
                ))
            .toList() ??
        [];
  }

  void _deleteEvent(Event event) {
    setState(() {
      _events[event.deadline]?.remove(event);
      if (_events[event.deadline]?.isEmpty ?? false) {
        _events.remove(event.deadline);
      }
    });
  }
}

class Event {
  final String title;
  final DateTime deadline;

  Event({required this.title, required this.deadline});
}
