import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:improov/src/core/widgets/custom_checkbox.dart';
import 'package:improov/src/core/widgets/focused_menu_wrapper.dart';
import 'package:improov/src/presentation/home/widgets/modals/screen/modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/features/habits/widgets/habit_popup.dart';

class HabitTile extends ConsumerWidget {
  final Habit habit;
  final Function(bool?)? onChanged;

  const HabitTile({
    super.key,
    required this.habit,
    required this.onChanged,
  });

  //edit function
  void onEditPressed(BuildContext context) {
    showModalBottomSheet(
      context: Navigator.of(context, rootNavigator: true).context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => Modal(
        habitToEdit: habit,
        isUpdating: true,
      )
    );
  }

  //delete function
  void onDeletePressed(WidgetRef ref, int id) {
    ref.read(habitNotifierProvider.notifier).deleteHabit(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //is habit completed today?
    final DateTime today = DateTime.now();
    final bool isCompletedToday = habit.completedDays.any((date) =>
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day
    );

    //calculating urgency
    final now = DateTime.now();
    final daysLeftInWeek = 8 - now.weekday;

    final int needs = habit.goalDaysPerWeek - habit.weeklyCount;
    final bool isUrgent = !isCompletedToday && (needs >= daysLeftInWeek) && needs > 0;

    return FocusedMenuWrapper(
      onEdit: () => onEditPressed(context),
      onDelete: () => onDeletePressed(ref, habit.id),
      onDetails: () {
        HapticFeedback.mediumImpact();
        Navigator.of(context, rootNavigator: true).push(
          PageRouteBuilder(
            opaque: false,
            barrierDismissible: true,
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return Stack(
                children: [

                  //B L U R
                  FadeTransition(
                    opacity: animation,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                  
                  //P O P U P
                  HabitPopup(habit: habit),
                ],
              );
            },
          ),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
                    
        //tap for check/uncheck
        onTap: () {
          ref.read(habitNotifierProvider.notifier).updateHabitCompletion(
            habit.id, 
            !isCompletedToday,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  left: BorderSide(
                    color: isUrgent ? Colors.red.shade300 : Colors.transparent,
                    width: 3,
                  ),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  //checkbox
                  Transform.scale(
                    scale: 1.2,
                    child: CustomCheckbox(
                      value: isCompletedToday, 
                      onChanged: onChanged
                    ),
                  ),
                    
                  const SizedBox(width: 12),
                    
                  //name & description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isCompletedToday
                              ? Colors.grey 
                              : Theme.of(context).colorScheme.inversePrimary,
                            decoration: isCompletedToday 
                              ? TextDecoration.lineThrough 
                              : null,
                            decorationColor: isCompletedToday
                              ? Colors.grey
                              : Colors.transparent,
                            fontStyle: isCompletedToday 
                              ? FontStyle.italic 
                              : null,
                          ),
                        ),
                        if (habit.description != null && habit.description!.isNotEmpty)
                          Text(
                            habit.description!,
                            style: TextStyle(
                              fontSize: 12, 
                              color: Colors.grey[600]
                            ),
                          ),
                      ],
                    ),
                  ),
                  //streak
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department_outlined,
                        size: 20,
                        color: isCompletedToday 
                          ? Theme.of(context).colorScheme.tertiary
                          : (isUrgent ? Colors.red.shade300 : Colors.grey),
                      ),
                      Text(
                        habit.displayedStreak.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isCompletedToday 
                          ? Theme.of(context).colorScheme.inversePrimary.withAlpha(190)
                          : Colors.grey,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}