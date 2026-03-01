import 'package:flutter/material.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:intl/intl.dart';

class HabitCalendarView extends StatefulWidget {
  final Habit habit;
  const HabitCalendarView({super.key, required this.habit});

  @override
  State<HabitCalendarView> createState() => _HabitCalendarViewState();
}

class _HabitCalendarViewState extends State<HabitCalendarView> {
  DateTime _viewDate = DateTime.now();

  void _moveMonth(int delta) {
    setState(() {
      _viewDate = DateTime(_viewDate.year, _viewDate.month + delta, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_viewDate.year, _viewDate.month, 1);
    final lastDayOfMonth = DateTime(_viewDate.year, _viewDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final leadingSpaces = firstDayOfMonth.weekday - 1;

    final completedSet = widget.habit.completedDays
      .map((d) => "${d.year}-${d.month}-${d.day}")
      .toSet();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //calendar header with navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.chevron_left, size: 20),
              onPressed: () => _moveMonth(-1),
            ),
            Text(
              DateFormat('MMMM yyyy').format(_viewDate),
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 20),
              onPressed: () => _moveMonth(1),
            ),
          ],
        ),

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
            final dateKey = "${_viewDate.year}-${_viewDate.month}-$day";
            
            //check completions
            final isCompleted = completedSet.contains(dateKey);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                const SizedBox(height: 6),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isCompleted ? Theme.of(context).colorScheme.tertiary : Colors.transparent,
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