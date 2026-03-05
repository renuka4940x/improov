import 'package:flutter/material.dart';
import 'package:improov/src/core/util/logic/heatmap_engine.dart';
import 'package:improov/src/data/enums/habit_status.dart';
import 'package:improov/src/data/models/habit.dart';

class HeatmapGrid extends StatelessWidget {
  final Habit habit;
  final DateTime targetMonth;

  const HeatmapGrid({
    super.key,
    required this.habit,
    required this.targetMonth,
  });

  @override
  Widget build(BuildContext context) {
    const double squareSize = 28;
    const double spacing = 12;

    final double rowWidth = (habit.goalDaysPerWeek * squareSize) + 
                          ((habit.goalDaysPerWeek - 1) * spacing);

    return FutureBuilder<List<List<HabitSquareStatus>>>(
      future: HeatmapEngine.getWeeklyStatusChunks(habit: habit, targetMonth: targetMonth),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
        }

        final rows = snapshot.data!;
        if (rows.isEmpty) return const SizedBox.shrink();

        return Center(
          child: SizedBox(
            width: rowWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rows.map((weekRow) {
                bool isFirstWeek = rows.indexOf(weekRow) == 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: spacing),
                  child: Row(
                    spacing: spacing,
                    mainAxisAlignment: isFirstWeek 
                      ? MainAxisAlignment.end 
                      : MainAxisAlignment.start,
                    children: weekRow.map((status) {
                      return Container(
                        width: squareSize,
                        height: squareSize,
                        decoration: BoxDecoration(
                          color: _getColor(context, status),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Color _getColor(BuildContext context, HabitSquareStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case HabitSquareStatus.completed:
        return colorScheme.tertiary;
      case HabitSquareStatus.overflow:
        return Colors.amberAccent;
      case HabitSquareStatus.empty:
        return Colors.grey.withOpacity(0.2);
      case HabitSquareStatus.skipped:
        return Colors.transparent;
    }
  }
}