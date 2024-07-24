import 'package:app/Pages/Navbar/tutorials.dart';
import 'package:app/Pages/Navbar/calendar.dart';
import 'package:app/Pages/Navbar/created_plan.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  List<Widget> _screens = [
    CreatedPlanHomePage(),
    CalendarPage(),
    Tutorial(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.description, size: _selectedIndex == 0 ? 35 : 25,),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: _selectedIndex == 1 ? 35 : 25,),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, size: _selectedIndex == 2 ? 35 : 25,),
            label: 'Tutorial',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (int index) {
          setState(() {
            print(index);
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
