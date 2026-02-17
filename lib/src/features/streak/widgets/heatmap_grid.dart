import 'package:flutter/material.dart';
import 'package:improov/src/core/constants/app_colors.dart';
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

    // Calculate width: (Goal * SquareSize) + (Spacing)
    final double squareSize = 25.0; 
    final double spacing = 4.0;
    final double gridWidth = (habit.goalDaysPerWeek * squareSize) + ((habit.goalDaysPerWeek - 1) * spacing);
    // FIX: FutureBuilder must match the Engine's return type
    return FutureBuilder<List<HabitSquareStatus>>(
      future: HeatmapEngine.getLinearStatuses(habit: habit, targetMonth: targetMonth),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
        }

        final statuses = snapshot.data!;
        if (statuses.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          width: gridWidth, // This stops the "Gigantic" effect
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
                  color: _getColor(statuses[index]),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color _getColor(HabitSquareStatus status) {
    switch (status) {
      case HabitSquareStatus.completed:
        return AppColors.slayGreen; // Your "Goal Met" Green
      case HabitSquareStatus.overflow:
        return Colors.amber;      // Your "Legend" Gold
      case HabitSquareStatus.empty:
        return Colors.grey.withOpacity(0.2); // Your "Gap" Gray
      default:
        return Colors.transparent;
    }
  }
}