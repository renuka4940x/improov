import 'package:flutter/material.dart';
import 'package:improov/src/data/database/isar_service.dart';
import 'package:improov/src/data/models/habit.dart';

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

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10)
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // M O N T H L Y  H E A D E R
                  Row(
                    children: List.generate(columnCount, (colIndex) {
                      final date = headerAnchor.add(Duration(days: colIndex * 7));
                      final monthLabels = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                        
                      // Only show month if it's the 1st col or the month changed from the previous col
                      bool showMonth = false;
                      if (colIndex == 0) {
                        showMonth = true;
                      } else {
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
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.6),
                            ),
                          )
                          : const SizedBox.shrink(),
                      );
                    }),
                  ),
                    
                  const SizedBox(height: 12),
              
                  // V E R T I C A L  S N A K E  G R I D
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(rowCount, (rowIndex) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                                  : Theme.of(context).colorScheme.tertiary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(2),
                                border: !isFilled 
                                  ? Border.all(
                                    color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1), 
                                    width: 0.5
                                    )
                                  : null,
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}