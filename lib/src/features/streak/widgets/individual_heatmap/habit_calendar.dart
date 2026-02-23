import 'package:flutter/material.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:intl/intl.dart';

class HabitCalendarView extends StatelessWidget {
  final Habit habit;

  const HabitCalendarView({
    super.key,
   required this.habit
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Get first day of current month
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final leadingSpaces = firstDayOfMonth.weekday - 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month Title
        Text(
          DateFormat('MMMM, yyyy').format(now),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),

        // The Calendar Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth + leadingSpaces,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),

          itemBuilder: (context, index) {
            if (index < leadingSpaces) return const SizedBox.shrink();

            final day = index - leadingSpaces + 1;
            final date = DateTime(now.year, now.month, day);
            
            // Check if this date is in habit.completedDays
            final isCompleted = habit.completedDays.any((d) => 
              d.year == date.year && d.month == date.month && d.day == date.day
            );

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // THE DATE NUMBER
                Text(
                  "$day",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted 
                        ? Theme.of(context).colorScheme.inversePrimary 
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                
                const SizedBox(height: 6), // Space between number and dot

                // THE SUCCESS DOT
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    // Only show the color if completed, otherwise transparent or a faint grey
                    color: isCompleted 
                        ? Theme.of(context).colorScheme.tertiary 
                        : Colors.transparent, 
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}