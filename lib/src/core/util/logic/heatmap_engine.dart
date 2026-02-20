import 'package:improov/src/data/enums/habit_status.dart';
import 'package:improov/src/data/models/habit.dart';

class HeatmapEngine {
  static Future<List<HabitSquareStatus>> getLinearStatuses({
  required Habit habit,
  required DateTime targetMonth,
}) async {
  final int goal = habit.goalDaysPerWeek;
  final DateTime monthStart = DateTime(targetMonth.year, targetMonth.month, 1);
  final DateTime monthEnd = DateTime(targetMonth.year, targetMonth.month + 1, 0);

  // 1. Start exactly on habit start date or month start
  DateTime gridStart = habit.startDate.isAfter(monthStart)
      ? DateTime(habit.startDate.year, habit.startDate.month, habit.startDate.day)
      : monthStart;

  final completionDates = habit.completedDays
      .map((d) => DateTime(d.year, d.month, d.day))
      .toSet();

  List<HabitSquareStatus> contractSquares = [];
  int totalOverflow = 0;
  DateTime currentWeekStart = gridStart;

  while (currentWeekStart.isBefore(monthEnd) || currentWeekStart.isAtSameMomentAs(monthEnd)) {
    // Determine the end of the current "Habit Week"
    // Usually Sunday, or the end of the month
    // 1. Determine the window end
    int daysUntilMonday = 8 - currentWeekStart.weekday;
    if (daysUntilMonday > 7) daysUntilMonday = 7;

    DateTime weekEnd = currentWeekStart.add(Duration(days: daysUntilMonday - 1));

    // CRITICAL: Ensure weekEnd NEVER goes past the last day of the month
    if (weekEnd.isAfter(monthEnd)) {
      weekEnd = DateTime(monthEnd.year, monthEnd.month, monthEnd.day);
    }

    // 2. Recalculate the actual days available in this final fragment
    int daysInThisWindow = weekEnd.difference(currentWeekStart).inDays + 1;

    // 3. The Adjusted Goal (The "Tail")
    // If daysInThisWindow is 2, and goal is 4, adjustedGoal MUST be 2.
    int adjustedGoal = (goal > daysInThisWindow) ? daysInThisWindow : goal;

    int countInWeek = 0;
    for (int i = 0; i < daysInThisWindow; i++) {
      DateTime checkDay = currentWeekStart.add(Duration(days: i));
      if (completionDates.contains(DateTime(checkDay.year, checkDay.month, checkDay.day))) {
        countInWeek++;
      }
    }

    // 3. Fill the Contract
    for (int i = 0; i < adjustedGoal; i++) {
      if (i < countInWeek) {
        contractSquares.add(HabitSquareStatus.completed);
      } else {
        contractSquares.add(HabitSquareStatus.empty);
      }
    }

    // 4. Track Overflow (Gold)
    if (countInWeek > adjustedGoal) {
      totalOverflow += (countInWeek - adjustedGoal);
    }

    // Move to next week
    currentWeekStart = weekEnd.add(const Duration(days: 1));
  }

  return [
    ...contractSquares,
    ...List.filled(totalOverflow, HabitSquareStatus.overflow)
  ];
}

  static Future<List<double>> getGlobalStatuses({
    required List<Habit> habits,
    required DateTime targetMonth,
  }) async {
    if (habits.isEmpty) return [];

    final DateTime monthStart = DateTime(targetMonth.year, targetMonth.month, 1);
    final DateTime monthEnd = DateTime(targetMonth.year, targetMonth.month + 1, 0);
    
    // 1. Find the earliest start date among all habits (Our Global Anchor)
    DateTime globalStart = habits
        .map((h) => h.startDate)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    
    // Normalize to month start if it started earlier
    if (globalStart.isBefore(monthStart)) globalStart = monthStart;

    // 2. Map every single day of the month to an intensity score
    Map<DateTime, double> dayIntensities = {};
    int totalDaysInMap = monthEnd.difference(globalStart).inDays + 1;

    for (int i = 0; i < totalDaysInMap; i++) {
      DateTime currentDay = globalStart.add(Duration(days: i));
      double activeHabits = 0;
      double completions = 0;

      for (var habit in habits) {
        // Only count the habit if it actually existed on this day
        if ((currentDay.isAfter(habit.startDate) || currentDay.isAtSameMomentAs(habit.startDate)) &&
            currentDay.month == targetMonth.month) {
          
          activeHabits++;
          
          bool isDone = habit.completedDays.any((d) => 
            d.year == currentDay.year && 
            d.month == currentDay.month && 
            d.day == currentDay.day
          );

          if (isDone) completions++;
        }
      }

      if (activeHabits > 0) {
        dayIntensities[currentDay] = completions / activeHabits;
      }
    }

    // 3. Convert that chronological map into the list of intensities for the grid
    return dayIntensities.values.toList();
  }
}