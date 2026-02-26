import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/core/util/provider/calendar_month_provider.dart';
import 'package:improov/src/presentation/home/widgets/modals/screen/modal.dart';
import 'package:improov/src/presentation/home/widgets/nav_bar.dart';

class PageNav extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const PageNav({
    super.key,
    required this.navigationShell,
  });

  void _handleNavigation(BuildContext context, WidgetRef ref, int index) {
    if (index != navigationShell.currentIndex) {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
         Navigator.of(context, rootNavigator: true).pop();
      }
      
      ref.read(calendarMonthProvider.notifier).resetToCurrent();

      navigationShell.goBranch(index);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              context: Navigator.of(context, rootNavigator: true).context,
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
        onTap: (index) => _handleNavigation(context, ref, index),
      ),
    );
  }
}