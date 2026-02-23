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

    // calculate width
    final double squareSize = 28; 
    final double spacing = 15;
    final double gridWidth = (habit.goalDaysPerWeek * squareSize) + ((habit.goalDaysPerWeek - 1) * spacing);
    
    return FutureBuilder<List<HabitSquareStatus>>(
      future: HeatmapEngine.getLinearStatuses(habit: habit, targetMonth: targetMonth),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
        }

        final statuses = snapshot.data!;
        if (statuses.isEmpty) return const SizedBox.shrink();

        return Center(
          child: SizedBox(
            width: gridWidth,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: habit.goalDaysPerWeek,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
              ),
              itemCount: statuses.length,
              itemBuilder: (context, index) {
                return Container(
                  width: squareSize,
                  height: squareSize,
                  decoration: BoxDecoration(
                    color: _getColor(context, statuses[index]),
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              },
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
        //goal met
        return colorScheme.tertiary;
      case HabitSquareStatus.overflow:
        // extra accomplishments
        return Colors.amberAccent;
      case HabitSquareStatus.empty:
        //gap
        return Colors.grey.withOpacity(0.3);
    }
  }
}