import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grant Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
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
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary, // Color for selected day
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary, // Color for selected day
              shape: BoxShape.circle,
            ),
            defaultTextStyle: TextStyle(
              color: Colors.black, // Default text color
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        onPressed: _showAddEventDialog,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    
    );
  }


  // ... (rest of the existing methods remain unchanged)

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

  void _showAddEventDialog() {
    // ... (existing method implementation)
  }

  void _deleteEvent(Event event) {
    // ... (existing method implementation)
  }
}

class Event {
  final String title;
  final DateTime deadline;

  Event({required this.title, required this.deadline});
}