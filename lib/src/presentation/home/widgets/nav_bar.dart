import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    Color getIconColor(int index) {
      //handle color swap
      return currentIndex == index
          ? Theme.of(context).colorScheme.inversePrimary
          : Colors.grey;
    }

    //handles foldersswap
    String getIconPath(int index, String iconName) {
      final folderName = currentIndex == index 
        ? 'filled_icons' 
        : 'dark_icons';
      return 'assets/icons/$folderName/$iconName.svg';
    }

    return BottomAppBar(
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //home
          IconButton(
            onPressed: () => onTap(0), 
            icon: SvgPicture.asset(
              getIconPath(0, 'home'),
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                getIconColor(0),
                BlendMode.srcIn,
              ),
            )
          ),

          //calendar
          IconButton(
            onPressed: () => onTap(1), 
            icon: SvgPicture.asset(
              getIconPath(1, 'calendar'),
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                getIconColor(1),
                BlendMode.srcIn,
              ),
            )
          ),

          //space for fab
          const SizedBox(width: 30),

          //streak
          IconButton(
            onPressed: () => onTap(2), 
            icon: SvgPicture.asset(
              getIconPath(2, 'streak'),
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                getIconColor(2),
                BlendMode.srcIn,
              ),
            )
          ),

          //profile
          IconButton(
            onPressed: () => onTap(3), 
            icon: SvgPicture.asset(
              getIconPath(3, 'profile'),
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                getIconColor(3),
                BlendMode.srcIn,
              ),
            )
          ),
        ],
      ),
    );
  }
}