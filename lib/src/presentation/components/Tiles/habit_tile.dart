import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:improov/src/data/database/habit_database.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/presentation/util/modals/modal.dart';
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
      context: context,
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

    //calculate streak 
    final int streakCount = habit.completedDays.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(), 
          children: [
            SlidableAction(
              //edit
              onPressed: (context) => onEditPressed(context),
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Colors.white,
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
                  color: isCompletedToday ? Colors.grey : null,
                ),
                Text(
                  streakCount.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCompletedToday ? Colors.grey : null,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}