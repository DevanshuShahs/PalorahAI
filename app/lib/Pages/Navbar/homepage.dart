import 'package:app/Pages/Navbar/personal_Helper.dart';
import 'package:app/Pages/Navbar/tutorials.dart';
import 'package:app/Pages/Navbar/calendar.dart';
import 'package:app/Pages/Navbar/created_plan.dart';
import 'package:app/Pages/Navbar/email_writer.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  final List<Widget> _screens = [
    const CreatedPlanHomePage(),
    const CalendarPage(),
    Tutorial(),
    const DonorDraft(),
    const Myhelper(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.description, size: _selectedIndex == 0 ? 35 : 25),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: _selectedIndex == 1 ? 35 : 25),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, size: _selectedIndex == 2 ? 35 : 25),
            label: 'Tutorial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email, size: _selectedIndex == 3 ? 35 : 25),
            label: 'DonorDraft',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_center, size: _selectedIndex == 4 ? 35 : 25),
            label: 'Helper',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey, // Set color for unselected items
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
