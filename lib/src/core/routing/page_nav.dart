import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:improov/src/features/modals/screen/modal.dart';
import 'package:improov/src/features/home/widgets/nav_bar.dart';

class PageNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const PageNav({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,

      //fab in the middle of navbar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 20),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            FocusScope.of(context).unfocus(); 

            showModalBottomSheet<void>(
              context: context, 
              builder: (context) => Modal(
                isUpdating: false,
                taskToEdit: null,
                habitToEdit: null,
              ),
              isScrollControlled: true,
              useSafeArea: true,
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
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
      ),
    );
  }
}