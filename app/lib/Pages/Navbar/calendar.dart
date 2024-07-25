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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
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
          markerDecoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
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

  Widget _buildEventLists() {
    final selectedDate = _selectedDay ?? _focusedDay;
    final todayEvents = _getEventsForDay(DateTime.now());
    final upcomingEvents = _getUpcomingEvents();
    final isPastDate = selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)));
    final List<Event> pastEvents = isPastDate ? _getPastEvents(selectedDate) : [];

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 30, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPastDate)
              _buildEventSection("Past plans", pastEvents, 
              "You were not busy on ${DateFormat('MMMMd').format(_selectedDay??DateTime.now())}"),
            const SizedBox(height: 16),
              _buildEventSection("Today's plan", todayEvents, "You are free today!"),
            const SizedBox(height: 16),
              _buildEventSection("Upcoming plans (${upcomingEvents.length})", upcomingEvents, "Nothing planned yet!"),
          ],
        ),
      ),
    );
  }

  List<Event> _getPastEvents(DateTime selectedDate) {
    return _events[_truncateTime(selectedDate)] ?? [];
  }

  Widget _buildEventSection(String title, List<Event> events, [String? message]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        events.isEmpty
            ? Text(message ?? "No events scheduled.", style: const TextStyle(fontSize: 15),)
            : Column(
                children: events.map((event) => _buildEventCard(event)).toList(),
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
        subtitle: Text(DateFormat('h:mm a').format(event.deadline)),
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
    DateTime endDate = fromDate.add(const Duration(days: 7)); // Get events for the next 7 days

    for (DateTime date = fromDate.add(const Duration(days: 1));
         date.isBefore(endDate);
         date = date.add(const Duration(days: 1))) {
      upcomingEvents.addAll(_getEventsForDay(date));
    }

    upcomingEvents.sort((a, b) => a.deadline.compareTo(b.deadline));
    return upcomingEvents;
  }

  void _showAddEventDialog() {
    // Implement add event dialog
  }
}

class Event {
  final String title;
  final DateTime deadline;
  final Color color;
  final IconData icon;

  Event({required this.title, required this.deadline, required this.color, required this.icon});
}