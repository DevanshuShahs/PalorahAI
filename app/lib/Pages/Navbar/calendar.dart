import 'package:app/Services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};

  late Future<String> _userNameFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _userNameFuture = fetchUserName();
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
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildCalendar()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder<String>(
              future: _userNameFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildShimmerEffect();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    snapshot.data ?? "Guest",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }
              }),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  DateFormat('d').format(DateTime.now()),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const SizedBox(width: 8),
              FutureBuilder<String>(
                future: _userNameFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text('Error', style: TextStyle(color: Colors.white)),
                    );
                  } else {
                    String userInitial =
                        snapshot.data != null && snapshot.data!.isNotEmpty
                            ? snapshot.data!.substring(0, 1)
                            : 'G';
                    return CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        userInitial,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar<Event>(
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
        cellMargin: EdgeInsets.zero,
        cellPadding: EdgeInsets.zero,
        defaultTextStyle: TextStyle(color: Colors.black),
        todayTextStyle: TextStyle(color: Colors.white),
        todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(color: Colors.white),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        markersMaxCount: 3,
        markersAlignment: Alignment.bottomCenter,
        markersOffset: const PositionedOffset(bottom: 4),
      ),
      
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, focusedDay);
        },
        todayBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, focusedDay, isToday: true);
        },
        selectedBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, focusedDay, isSelected: true);
        },
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.grey[600]),
        weekendStyle: TextStyle(color: Colors.grey[600]),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: Icon(Icons.chevron_left),
        rightChevronIcon: Icon(Icons.chevron_right),
        titleTextStyle: TextStyle(fontSize: 17),
      ),
      rowHeight: (MediaQuery.of(context).size.height * 0.75) / 6,
    );
  }

  Widget _buildDayCell(DateTime day, DateTime focusedDay,
      {bool isToday = false, bool isSelected = false}) {
    final events = _events[_truncateTime(day)] ?? [];
    final isOutside = day.month != focusedDay.month;

    return Container(
      width: MediaQuery.sizeOf(context).width/7,
        decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
        color: isToday
          ?         Theme.of(context).colorScheme.primary.withOpacity(0.5)
          : isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              color: isOutside
                  ? Colors.grey
                  : (isToday ? Colors.white : isSelected ? Colors.white : Colors.black),
              fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          ...events.map((event) => _buildEventIndicator(event)).toList(),
        ],
      ),
    );
  }

  Widget _buildEventIndicator(Event event) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: event.color,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        event.title,
        style: const TextStyle(color: Colors.white, fontSize: 10),
        overflow: TextOverflow.ellipsis,
      ),
    );
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
                        decoration:
                            const InputDecoration(labelText: 'Event Title'),
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
                              child: Text(
                                DateFormat('yyyy-MM-dd').format(_date),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildColorButton(Colors.blue, _selectedColor,
                              (color) {
                            setState(() {
                              _selectedColor = color;
                            });
                          }),
                          _buildColorButton(Colors.green, _selectedColor,
                              (color) {
                            setState(() {
                              _selectedColor = color;
                            });
                          }),
                          _buildColorButton(Colors.red, _selectedColor,
                              (color) {
                            setState(() {
                              _selectedColor = color;
                            });
                          }),
                          _buildColorButton(Colors.purple, _selectedColor,
                              (color) {
                            setState(() {
                              _selectedColor = color;
                            });
                          }),
                          _buildColorButton(Colors.orange, _selectedColor,
                              (color) {
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
                          _buildIconButton(Icons.celebration, _selectedIcon,
                              (icon) {
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

  Widget _buildColorButton(
      Color color, Color selectedColor, ValueChanged<Color> onTap) {
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: selectedColor == color
              ? Border.all(color: Colors.black.withOpacity(0.2), width: 2)
              : null,
          boxShadow: selectedColor == color
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ]
              : [],
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, IconData selectedIcon, ValueChanged<IconData> onTap) {
    return GestureDetector(
      onTap: () => onTap(icon),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: selectedIcon == icon ? Colors.grey[400] : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: selectedIcon == icon
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
      ),
    );
  }
}

Widget buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Container(
          width: 100,
          height: 20,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Container(
          width: 150,
          height: 20,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Container(
          width: 100,
          height: 20,
          color: Colors.white,
        ),
      ],
    ),
  );
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
