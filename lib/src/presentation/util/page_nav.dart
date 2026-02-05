import 'package:flutter/material.dart';
import 'package:improov/src/presentation/components/nav_bar.dart';
import 'package:improov/src/presentation/pages/calendar_page.dart';
import 'package:improov/src/presentation/pages/home_page.dart';
import 'package:improov/src/presentation/pages/profile_page.dart';
import 'package:improov/src/presentation/pages/streak_page.dart';
import 'package:improov/src/presentation/util/modals/modal.dart';

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
      //returns specific page for the selected index
      body: _pages[_selectedIndex],

      //fab in the middle of navbar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 20),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            showModalBottomSheet<void> (
              context: context, 
              builder: (context) => Modal(),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          child: Icon(
            Icons.add, 
            color: Theme.of(context).colorScheme.inversePrimary,
            ),
        ),
      ),

      //the navigation bar
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => _navigateBottomBar(index),
      ),
    );
  }
}