import 'package:flutter/material.dart';
import 'package:improov/src/data/database/isar_service.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/features/streak/widgets/individual_heatmap/habit_calendar.dart';

class YearlySnakeGrid extends StatelessWidget {
  final int habitId;
  final int columnCount = 26;

  const YearlySnakeGrid({super.key, required this.habitId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Habit?>(
      stream: IsarService.db.habits.watchObject(habitId, fireImmediately: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final habit = snapshot.data!;
        final int rowCount = habit.goalDaysPerWeek;
        final totalCompletions = habit.completedDays.length;
        final DateTime startDate = habit.startDate;

        final int daysSinceStart = DateTime.now().difference(startDate).inDays;
        final int currentWeekCount = (daysSinceStart / 7).ceil();

        final int weekOffset = currentWeekCount > columnCount ? (currentWeekCount - columnCount) : 0;

        final DateTime windowStartDate = startDate.add(Duration(days: weekOffset * 7));
        final DateTime headerAnchor = windowStartDate.subtract(Duration(days: windowStartDate.weekday - 1));

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. THE SNAKE (Needs a fixed width wrap to prevent overflow error)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, 
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- MONTH HEADER ---
                          Row(
                            children: List.generate(columnCount, (colIndex) {
                              final date = headerAnchor.add(Duration(days: colIndex * 7));
                              final monthLabels = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                              
                              bool showMonth = (colIndex == 0);
                              if (colIndex > 0) {
                                final prevDate = headerAnchor.add(Duration(days: (colIndex - 1) * 7));
                                if (date.month != prevDate.month) showMonth = true;
                              }

                              return SizedBox(
                                width: 13,
                                child: showMonth 
                                  ? Text(
                                      monthLabels[date.month], 
                                      softWrap: false, 
                                      overflow: TextOverflow.visible, 
                                      style: TextStyle(
                                        fontSize: 10, 
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.6),
                                      ),
                                    ) 
                                  : const SizedBox.shrink(),
                              );
                            }),
                          ),
                          const SizedBox(height: 10),
                          // --- THE GRID ---
                          ...List.generate(rowCount, (rowIndex) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1.5),
                              child: Row(
                                children: List.generate(columnCount, (colIndex) {
                                  final int globalWeekIndex = weekOffset + colIndex;
                                  final int linearIndex = (globalWeekIndex * rowCount) + rowIndex;
                                  final bool isFilled = linearIndex < totalCompletions;

                                  return Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                    decoration: BoxDecoration(
                                      color: isFilled 
                                          ? Theme.of(context).colorScheme.tertiary 
                                          : Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  );
                                }),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Colors.grey, thickness: 0.5),
                  ),
                  
                  // 2. THE CALENDAR (Stationary)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: HabitCalendarView(habit: habit),
                  ),

                  const SizedBox(height: 16)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}