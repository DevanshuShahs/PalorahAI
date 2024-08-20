import 'package:app/Services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collection/collection.dart';
import 'package:collection/collection.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Future<String> _userNameFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _userNameFuture = fetchUserName();
    _selectedDay = _focusedDay;
    _events = {};
    _fetchEvents();
    _listenToPlanUpdates();
// Fetch events from Firestore
  }

  void _listenToPlanUpdates() {
    FirebaseFirestore.instance
        .collection('plans')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) {
          parsePlanAndCreateEvents(change.doc.data()!, change.doc.id);
        }
      }
    });
  }

  DateTime _truncateTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  Future<void> parsePlanAndCreateEvents(
      Map<String, dynamic> plan, String planId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String planName = plan['planName'] ?? 'Unnamed Plan';
    final Timestamp planTimestamp = plan['timestamp'] ?? Timestamp.now();
    final List<dynamic> steps = plan['plan'] ?? [];

    List<Event> eventsToAdd = [];

    for (int i = 0; i < steps.length; i++) {
      final Map<String, dynamic> step =
          steps[i] is Map<String, dynamic> ? steps[i] : {};
      final String title = step['title'] ?? 'Untitled Step';
      final List<dynamic> substeps = step['substeps'] ?? [];

      String? timelineString = substeps
          .firstWhere(
            (substep) => substep.toString().toLowerCase().contains('timeline:'),
            orElse: () => null,
          )
          ?.toString();

      if (timelineString != null) {
        int? days = parseTimelineString(timelineString);
        if (days != null) {
          DateTime eventDate = planTimestamp.toDate().add(Duration(days: days));

          Event newEvent = Event(
            userId: user.uid,
            planId: planId,
            stepIndex: i,
            title: '$planName - ${title.replaceAll('*', '')}',
            deadline: eventDate,
            color: Colors.blue,
            icon: Icons.event,
            notes: 'Timeline: $timelineString',
          );

          eventsToAdd.add(newEvent);
        }
      }
    }

    // Use a batch write to add or update events
    WriteBatch batch = _firestore.batch();
    for (Event event in eventsToAdd) {
      DocumentReference eventRef = _firestore
          .collection('events')
          .doc('${event.planId}_${event.stepIndex}');
      batch.set(eventRef, event.toMap(), SetOptions(merge: true));
    }

    await batch.commit();
    _fetchEvents(); // Refresh events after adding new ones
  }

  Future<void> _fetchEvents() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final querySnapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: user.uid)
          .get();

      final events = querySnapshot.docs
          .map((doc) => Event.fromMap(doc.data(), doc.id))
          .toList();

      setState(() {
        _events = groupEventsByDate(events);
      });
    }
  }

  Map<DateTime, List<Event>> groupEventsByDate(List<Event> events) {
    return groupBy(
        events,
        (Event e) =>
            DateTime(e.deadline.year, e.deadline.month, e.deadline.day));
  }

  int? parseTimelineString(String timeline) {
    final RegExp monthRegExp = RegExp(r'(\d+)\s*(month|months|mon)');
    final RegExp weekRegExp = RegExp(r'(\d+)\s*(week|weeks|wk|wks)');

    final monthMatch = monthRegExp.firstMatch(timeline);
    if (monthMatch != null) {
      int months = int.parse(monthMatch.group(1)!);
      return months * 30; // Approximate days in a month
    }

    final weekMatch = weekRegExp.firstMatch(timeline);
    if (weekMatch != null) {
      int weeks = int.parse(weekMatch.group(1)!);
      return weeks * 7; // Days in a week
    }

    return null; // If neither month nor week is found
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(
                height: MediaQuery.of(context).size.height -
                    100, // Adjust height as needed
                child: _buildCalendar(),
              ),
            ],
          ),
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
                      child: const Text('Error',
                          style: TextStyle(color: Colors.white)),
                    );
                  } else {
                    String userInitial =
                        snapshot.data != null && snapshot.data!.isNotEmpty
                            ? snapshot.data!.substring(0, 1)
                            : 'G';
                    return CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        userInitial,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
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
        defaultTextStyle: const TextStyle(color: Colors.black),
        todayTextStyle: const TextStyle(color: Colors.white),
        todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(color: Colors.white),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        markerSize: 0,
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
        outsideBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, focusedDay);
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
      daysOfWeekHeight:
          39.5, // Add this line to increase the height of the days of the week row

      rowHeight: (MediaQuery.of(context).size.height * 0.8) / 6,
    );
  }

  Widget _buildDayCell(DateTime day, DateTime focusedDay,
      {bool isToday = false, bool isSelected = false}) {
    final events = _events[_truncateTime(day)] ?? [];
    final isOutside = day.month != focusedDay.month;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
          _focusedDay = day;
        });
        if (events.isNotEmpty) {
          _showEventListDialog(events);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 7,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 0.5),
          color: isSelected ? Colors.grey[200] : Colors.transparent,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                      : isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isOutside
                          ? (isSelected ? Colors.white : Colors.grey)
                          : (isSelected ? Colors.white : Colors.black),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            ...events.map((event) => _buildEventIndicator(event)).toList(),
          ],
        ),
      ),
    );
  }

  void _showEventListDialog(List<Event> events) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Events for ${DateFormat('MMM d, yyyy').format(_selectedDay!)}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: events
                  .map((event) => ListTile(
                        leading: Icon(event.icon, color: event.color),
                        title: Text(event.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notes: ${event.notes}',
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,
                                  color: Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _showEditEventDialog(event);
                              },
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditEventDialog(Event event) {
    final _formKey = GlobalKey<FormState>();
    String _title = event.title;
    DateTime _date = event.deadline;
    Color _selectedColor = event.color;
    IconData _selectedIcon = event.icon;
    String _notes = event.notes;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Event'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: _title,
                        decoration: const InputDecoration(
                            labelText: 'Event Title (Required)'),
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
                      TextFormField(
                        initialValue: _notes,
                        decoration: const InputDecoration(
                            labelText: 'Notes (Optional)'),
                        onSaved: (value) {
                          _notes = value ?? 'None';
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: const Icon(Icons.calendar_month_rounded),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFd0dacc).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _date,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null && picked != _date) {
                                    setState(() {
                                      _date = DateTime(
                                        picked.year,
                                        picked.month,
                                        picked.day,
                                        _date.hour,
                                        _date.minute,
                                      );
                                    });
                                  }
                                },
                                child: Text(
                                  DateFormat('MMM d, yyyy').format(_date),
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Color(0xFFe9837e),
                                  ),
                                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteEventFromFirestore(event);
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final User? user = _auth.currentUser;
                          if (user != null) {
                            final updatedEvent = Event(
                              userId: user.uid,

                              id: event.id, // Ensure the ID is passed correctly
                              title: _title,
                              deadline: _date,
                              color: _selectedColor,
                              icon: _selectedIcon,
                              notes: _notes,
                            );
                            _updateEventInFirestore(event, updatedEvent);
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  void _updateEvent(Event oldEvent, Event updatedEvent) {
    setState(() {
      // Remove the old event
      final oldEventDate = _truncateTime(oldEvent.deadline);
      _events[oldEventDate]?.removeWhere((event) => event.id == oldEvent.id);
      if (_events[oldEventDate]?.isEmpty ?? false) {
        _events.remove(oldEventDate);
      }

      // Add the updated event
      final updatedEventDate = _truncateTime(updatedEvent.deadline);
      if (!_events.containsKey(updatedEventDate)) {
        _events[updatedEventDate] = [];
      }
      _events[updatedEventDate]!.add(updatedEvent);

      // Update selected and focused day
      _selectedDay = updatedEventDate;
      _focusedDay = updatedEventDate;

      // Sort events for the updated date
      _events[updatedEventDate]!
          .sort((a, b) => a.deadline.compareTo(b.deadline));
    });
  }

  void _deleteEvent(Event event) {
    setState(() {
      final eventDate = _truncateTime(event.deadline);
      _events[eventDate]!.remove(event);
      if (_events[eventDate]!.isEmpty) {
        _events.remove(eventDate);
      }
      // If we've deleted all events for the selected day, update the selected day
      if (!_events.containsKey(_selectedDay)) {
        _selectedDay = _focusedDay;
      }
    });
    _deleteEventFromFirestore(event);
  }



  // Add an event to Firestore
  Future<void> _addEventToFirestore(Event event) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      // Check if an event with the same title and date already exists
      final querySnapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: user.uid)
          .where('title', isEqualTo: event.title)
          .where('deadline', isEqualTo: event.deadline.toIso8601String())
          .get();

      if (querySnapshot.docs.isEmpty) {
        final eventMap = event.toMap();
        eventMap['userId'] = user.uid;
        final docRef = await _firestore.collection('events').add(eventMap);
        event.id = docRef.id;
        print("Added event to Firestore: ${event.title}");
        _addEvent(event);
      } else {
        print("Event already exists: ${event.title}");
      }
    } else {
      print('No user signed in when adding event to Firestore');
    }
  }

  Future<void> _updateEventInFirestore(
      Event oldEvent, Event updatedEvent) async {
    final User? user = _auth.currentUser;
    if (user != null && oldEvent.userId == user.uid) {
      try {
        await _firestore
            .collection('events')
            .doc(updatedEvent.id)
            .update(updatedEvent.toMap());
        _updateEvent(oldEvent, updatedEvent);
      } catch (e) {
        print('Error updating event in Firestore: $e');
      }
    } else {
      print('User not authorized to update this event');
    }
  }

  Future<void> _deleteEventFromFirestore(Event event) async {
    final User? user = _auth.currentUser;
    if (user != null && event.userId == user.uid) {
      await _firestore.collection('events').doc(event.id).delete();
      _deleteEvent(event);
    } else {
      print('User not authorized to delete this event');
    }
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
    String _notes = '';

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
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Notes'),
                        onSaved: (value) {
                          _notes = value ?? '';
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: const Icon(Icons.calendar_month_rounded),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFd0dacc).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _date,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null && picked != _date) {
                                    setState(() {
                                      _date = picked;
                                    });
                                  }
                                },
                                child: Text(
                                  DateFormat('MMM d, yyyy').format(_date),
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Color(0xFFe9837e),
                                  ),
                                ),
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
                      final User? user = _auth.currentUser;
                      if (user != null) {
                        final newEvent = Event(
                          userId: user.uid,
                          title: _title,
                          deadline: DateTime(
                            _date.year,
                            _date.month,
                            _date.day,
                          ),
                          color: _selectedColor,
                          icon: _selectedIcon,
                          notes: _notes,
                        );
                        _addEventToFirestore(newEvent);
                        Navigator.of(context).pop();
                      } else {
                        // Handle the case where no user is signed in
                        print('No user signed in');
                      }
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

  void _addEvent(Event newEvent) {
    setState(() {
      final eventDate = _truncateTime(newEvent.deadline);
      if (_events.containsKey(eventDate)) {
        _events[eventDate]!.add(newEvent);
      } else {
        _events[eventDate] = [newEvent];
      }
      _selectedDay = eventDate;
      _focusedDay = eventDate;
    });
    print("Added event to local state: ${newEvent.title}");
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
   String? id;
  final String userId;
   String? planId;
   int? stepIndex;
  final String title;
  final DateTime deadline;
  final Color color;
  final IconData icon;
  final String notes;

  Event({
     this.id,
    required this.userId,
     this.planId,
     this.stepIndex,
    required this.title,
    required this.deadline,
    required this.color,
    required this.icon,
    this.notes = 'No notes',
  });


 Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'planId': planId,
      'stepIndex': stepIndex,
      'title': title,
      'deadline': deadline.toIso8601String(),
      'color': color.value,
      'icon': icon.codePoint,
      'notes': notes,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      userId: map['userId'],
      planId: map['planId'],
      stepIndex: map['stepIndex'],
      title: map['title'],
      deadline: DateTime.parse(map['deadline']),
      color: Color(map['color']),
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      notes: map['notes'],
    );
  }
}