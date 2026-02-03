import 'package:flutter/material.dart';
import 'package:improov/components/nav_bar.dart';
import 'package:improov/pages/calendar_page.dart';
import 'package:improov/pages/home_page.dart';
import 'package:improov/pages/profile_page.dart';
import 'package:improov/pages/streak_page.dart';

class PageNav extends StatefulWidget {
  const PageNav({super.key});

  @override
  State<PageNav> createState() => _PageNavState();
}

class _PageNavState extends State<PageNav> {
   //keeps track of the current page to display  
  int _selectedIndex = 0;
  
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    //homepage
    HomePage(),

    //calendar
    CalendarPage(),

    //streak
    StreakPage(),

    //profile
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 20),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {},
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          child: Icon(
            Icons.add, 
            color: Theme.of(context).colorScheme.inversePrimary,
            ),
        ),
      ),

      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => _navigateBottomBar(index),
      ),
    );
  }
}