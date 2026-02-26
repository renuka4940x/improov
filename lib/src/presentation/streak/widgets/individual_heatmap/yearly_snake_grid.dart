import 'package:flutter/material.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart';
import 'package:improov/src/presentation/streak/widgets/individual_heatmap/habit_calendar.dart';

class YearlySnakeGrid extends ConsumerWidget {
  final int habitId;
  final int columnCount = 26;

  const YearlySnakeGrid({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch habit notifier
    final habitsAsync = ref.watch(habitNotifierProvider);

    return habitsAsync.when(
      data: (habits) {
        //find the specific habit in the list
        final habit = habits.firstWhere(
          (h) => h.id == habitId,
          orElse: () => Habit(),
        );

        //if the habit is dummy/newly deleted, don't show anything
        if (habit.id == -1) return const SizedBox.shrink();

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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,

              width: MediaQuery.of(context).size.width * 0.92,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              margin: const EdgeInsets.symmetric(horizontal: 12),

              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),

              child: AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8, 
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // M O N T H  H E A D E R
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

                            // G R I D 
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
                    
                    // C A L E N D A R 
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: HabitCalendarView(habit: habit),
                    ),
                
                    const SizedBox(height: 16)
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => const SizedBox.shrink(),
    );
  }
}