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
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = {
      _truncateTime(DateTime.now().subtract(const Duration(days: 2))): [
        Event(
          title: "Past Meeting",
          deadline: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
          color: Colors.grey,
          icon: Icons.history,
        ),
      ],
      _truncateTime(DateTime.now()): [
        Event(
          title: "Dinner with Obama",
          deadline: DateTime.now().add(const Duration(hours: 6)),
          color: Colors.blue,
          icon: Icons.dinner_dining,
        ),
      ],
      _truncateTime(DateTime.now().add(const Duration(days: 1))): [
        Event(
          title: "Biz trip to Italy",
          deadline: DateTime.now().add(const Duration(days: 1, hours: 9)),
          color: Colors.purple,
          icon: Icons.flight,
        ),
        Event(
          title: "Government meetings",
          deadline: DateTime.now().add(const Duration(days: 1, hours: 14)),
          color: Colors.pink,
          icon: Icons.meeting_room,
        ),
      ],
    };
  }

  DateTime _truncateTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCalendar(),
            Expanded(
              child: _buildEventLists(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM').format(_focusedDay),
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Implement settings functionality
            },
          ),
        ],
      ),
    );
  }

 Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TableCalendar<Event>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        eventLoader: (day) => _events[_truncateTime(day)] ?? [],
        calendarStyle: CalendarStyle(
          outsideDaysVisible: true,
          outsideTextStyle: const TextStyle(color: Colors.grey),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              );
            }
            return null;
          },
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          weekendStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          leftChevronIcon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.primary),
          rightChevronIcon: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

   Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: events.first.color.withOpacity(0.3),
      ),
      width: 20,
      height: 20,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle(
            color: events.first.color,
            fontSize: 9,
          ),
        ),
      ),
    );
  }

  Widget _buildEventLists() {
    final selectedDate = _selectedDay ?? _focusedDay;
    final todayEvents = _getEventsForDay(DateTime.now());
    final upcomingEvents = _getUpcomingEvents();
    final isPastDate =
        selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)));
    final List<Event> pastEvents =
        isPastDate ? _getPastEvents(selectedDate) : [];

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 30, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPastDate)
              _buildEventSection("Past plans", pastEvents,
                  "You were not busy on ${DateFormat('MMMMd').format(_selectedDay ?? DateTime.now())}"),
            const SizedBox(height: 16),
            _buildEventSection(
                "Today's plan", todayEvents, "You are free today!"),
            const SizedBox(height: 16),
            _buildEventSection("Upcoming plans (${upcomingEvents.length})",
                upcomingEvents, "Nothing planned yet!"),
          ],
        ),
      ),
    );
  }

  List<Event> _getPastEvents(DateTime selectedDate) {
    return _events[_truncateTime(selectedDate)] ?? [];
  }

  Widget _buildEventSection(String title, List<Event> events,
      [String? message]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        events.isEmpty
            ? Text(
                message ?? "No events scheduled.",
                style: const TextStyle(fontSize: 15),
              )
            : Column(
                children:
                    events.map((event) => _buildEventCard(event)).toList(),
              ),
      ],
    );
  }

  Widget _buildEventCard(Event event) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: event.color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(event.icon, color: Colors.white),
        ),
        title: Text(event.title),
        subtitle: Text(DateFormat('MMMMd').format(event.deadline)),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  List<Event> _getUpcomingEvents() {
    DateTime fromDate = DateTime.now();
    List<Event> upcomingEvents = [];
    DateTime endDate =
        fromDate.add(const Duration(days: 7)); // Get events for the next 7 days

    for (DateTime date = fromDate.add(const Duration(days: 1));
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      upcomingEvents.addAll(_getEventsForDay(date));
    }

    upcomingEvents.sort((a, b) => a.deadline.compareTo(b.deadline));
    return upcomingEvents;
  }

 void _showAddEventDialog() {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime _date = _selectedDay ?? DateTime.now();
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.event;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add New Event'),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Event Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an event title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _title = value!;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _date,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null && picked != _date) {
                                setState(() {
                                  _date = picked;
                                });
                              }
                            },
                            child: Text(DateFormat('yyyy-MM-dd').format(_date), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildColorButton(Colors.blue, _selectedColor, (color) {
                          setState(() {
                            _selectedColor = color;
                          });
                        }),
                        _buildColorButton(Colors.green, _selectedColor, (color) {
                          setState(() {
                            _selectedColor = color;
                          });
                        }),
                        _buildColorButton(Colors.red, _selectedColor, (color) {
                          setState(() {
                            _selectedColor = color;
                          });
                        }),
                        _buildColorButton(Colors.purple, _selectedColor, (color) {
                          setState(() {
                            _selectedColor = color;
                          });
                        }),
                        _buildColorButton(Colors.orange, _selectedColor, (color) {
                          setState(() {
                            _selectedColor = color;
                          });
                        }),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIconButton(Icons.event, _selectedIcon, (icon) {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        }),
                        _buildIconButton(Icons.work, _selectedIcon, (icon) {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        }),
                        _buildIconButton(Icons.school, _selectedIcon, (icon) {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        }),
                        _buildIconButton(Icons.sports, _selectedIcon, (icon) {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        }),
                        _buildIconButton(Icons.celebration, _selectedIcon, (icon) {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newEvent = Event(
                      title: _title,
                      deadline: DateTime(
                        _date.year,
                        _date.month,
                        _date.day,
                      ),
                      color: _selectedColor,
                      icon: _selectedIcon,
                    );
                    setState(() {
                      final eventDate = _truncateTime(newEvent.deadline);
                      if (_events.containsKey(eventDate)) {
                        _events[eventDate]!.add(newEvent);
                      } else {
                        _events[eventDate] = [newEvent];
                      }
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}

  Widget _buildColorButton(Color color, Color selectedColor, ValueChanged<Color> onTap) {
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
                  border: selectedColor == color ? Border.all(color: Colors.black.withOpacity(0.2), width: 2) : null,
          boxShadow: selectedColor == color ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 6,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ] : [],
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, IconData selectedIcon, ValueChanged<IconData> onTap) {
    return GestureDetector(
      onTap: () => onTap(icon),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: selectedIcon == icon ? Colors.grey[400] : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: selectedIcon == icon ? Theme.of(context).colorScheme.primary : Colors.grey,),
      ),
    );
  }
}

class Event {
  final String title;
  final DateTime deadline;
  final Color color;
  final IconData icon;

  Event(
      {required this.title,
      required this.deadline,
      required this.color,
      required this.icon});
}
