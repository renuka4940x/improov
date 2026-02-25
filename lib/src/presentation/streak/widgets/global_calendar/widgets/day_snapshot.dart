import 'package:improov/src/data/models/habit.dart';

class DaySnapshot {
  final int completedCount;
  final bool hasOrigin;
  final List<Habit> completedHabits;

  DaySnapshot({
    required this.completedCount,
    required this.hasOrigin,
    required this.completedHabits,
  });

  //factory for empty days
  factory DaySnapshot.empty() => DaySnapshot(
    completedCount: 0,
    hasOrigin: false,
    completedHabits: [],
  );
}