import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:improov/src/features/home/widgets/modals/screen/modal.dart';
import 'package:improov/src/features/habits/provider/habit_database.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/features/habits/widgets/habit_popup.dart';
import 'package:improov/src/core/routing/hero_dialog_route.dart';
import 'package:provider/provider.dart';

class HabitTile extends StatelessWidget {
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
  void onDeletePressed(BuildContext context) {
    context.read<HabitDatabase>().deleteHabit(habit.id);
  }

  @override
  Widget build(BuildContext context) {
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

    return Hero(
      tag: 'habit_${habit.id}',
      child: GestureDetector(
        //long press for popup
        onLongPress: () {
          HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            HeroDialogRoute(
              builder: (context) => HabitPopup(habit: habit,)
            )
          );
        },
                          
        //tap for check/uncheck
        onTap: () {
          context.read<HabitDatabase>().updateHabitCompletion(
            habit.id, 
            !habit.isCompleted,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const StretchMotion(), 
              children: [
                SlidableAction(
                  //edit
                  onPressed: (context) => onEditPressed(context),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Colors.grey,
                  icon: Icons.edit,
                  borderRadius: BorderRadius.circular(8),
                ),
                    
                //delete
                SlidableAction(
                  onPressed: (context) => onDeletePressed(context),
                  backgroundColor: Colors.red.shade300,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    left: BorderSide(
                      color: isUrgent ? Colors.red.shade300 : Colors.transparent,
                      width: 4,
                    ),
                  ),
                ),
                padding: isUrgent ? const EdgeInsets.only(left: 16) : EdgeInsets.all(0),
                child: Row(
                  children: [
                    //checkbox
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        side: BorderSide(
                          color: isCompletedToday
                            ? Colors.transparent
                            : Theme.of(context).colorScheme.inversePrimary,
                          width: 1.5,
                        ),
                        value: isCompletedToday, 
                        onChanged: onChanged,
                        activeColor: Theme.of(context).colorScheme.tertiary,
                        checkColor: Theme.of(context).colorScheme.inversePrimary,
                        
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                              decoration: isCompletedToday ? TextDecoration.lineThrough : null,
                              fontStyle: isCompletedToday ? FontStyle.italic : null,
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
      ),
    );
  }
}