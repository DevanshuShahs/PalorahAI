import 'package:app/Pages/Tutorials.dart';
import 'package:app/Pages/home_page.dart';
import 'package:app/Pages/userPlan.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../Services/authentication.dart';


class CreatedPlanHomePage extends StatefulWidget {
  const CreatedPlanHomePage({super.key});

  @override
  State<CreatedPlanHomePage> createState() => _CreatedPlanHomePageState();
}

class _CreatedPlanHomePageState extends State<CreatedPlanHomePage> {
  int _selectedIndex = 0;
  final GlobalKey<CalendarPageState> _calendarKey = GlobalKey<CalendarPageState>();

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const PlanContent(),
      CalendarPage(key: _calendarKey),
      // TutorialPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          title: const Text('Add New Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(hintText: "Enter event title"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Select Date'),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null && picked != selectedDate) {
                    selectedDate = picked;
                  }
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Tutorial(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Tutorials',
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (title.isNotEmpty) {
                  _calendarKey.currentState?.addEvent(title, selectedDate);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Home'),
      ),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: _showAddEventDialog,
              child: Icon(Icons.add,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.description, size: 40,),
            label: 'Plan',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: 40, ),
            label: 'Calendar',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, size: 40,),
            label: 'Tutorial',
            backgroundColor: Colors.purple,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PlanContent extends StatelessWidget {
  const PlanContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('images/PCLogo.png'),
              ),
              const SizedBox(width: 15),
              FutureBuilder<String>(
                future: fetchUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildShimmerEffect();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello again!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          snapshot.data ?? 'Guest',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'FINANCIAL BEGINNER',
                          style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement view plan functionality
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('View plan', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement create new plan functionality
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Create new plan', style: TextStyle(fontSize: 18)),
          ),
        ],
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