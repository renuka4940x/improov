import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //home
          IconButton(
            onPressed: () => onTap(0), 
            icon: Icon(
              Icons.home_rounded,
              color: currentIndex == 0
                ? Theme.of(context).colorScheme.inversePrimary 
                : Colors.grey,
            )
          ),

          //calendar
          IconButton(
            onPressed: () => onTap(1), 
            icon: Icon(
              Icons.calendar_today_rounded,
              color: currentIndex == 1
                ? Theme.of(context).colorScheme.inversePrimary 
                : Colors.grey,
            )
          ),

          //space for fab
          const SizedBox(width: 40),

          //streak
          IconButton(
            onPressed: () => onTap(2), 
            icon: Icon(
              Icons.local_fire_department_rounded,
              color: currentIndex == 2
                ? Theme.of(context).colorScheme.inversePrimary 
                : Colors.grey,
            )
          ),

          //profile
          IconButton(
            onPressed: () => onTap(3), 
            icon: Icon(
              Icons.person_2_rounded,
              color: currentIndex == 3
                ? Theme.of(context).colorScheme.inversePrimary 
                : Colors.grey,
            )
          ),
        ],
      ),
    );
  }
}