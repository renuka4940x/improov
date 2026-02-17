import 'package:improov/src/data/enums/habit_status.dart';
import 'package:improov/src/data/models/habit.dart';

class HeatmapEngine {
  static int getExpectedSlots({required Habit habit, required DateTime targetMonth}) {
    final lastDayOfMonth = DateTime(targetMonth.year, targetMonth.month + 1, 0);
    DateTime startPoint = (habit.startDate.isAfter(DateTime(targetMonth.year, targetMonth.month, 1)))
        ? DateTime(habit.startDate.year, habit.startDate.month, habit.startDate.day)
        : DateTime(targetMonth.year, targetMonth.month, 1);
    final daysInWindow = lastDayOfMonth.difference(startPoint).inDays + 1;
    return ((daysInWindow / 7) * habit.goalDaysPerWeek).floor(); 
  }

  static Future<List<HabitSquareStatus>> getLinearStatuses({
    required Habit habit,
    required DateTime targetMonth,
  }) async {
    final int goal = habit.goalDaysPerWeek;
    final DateTime monthStart = DateTime(targetMonth.year, targetMonth.month, 1);
    final DateTime monthEnd = DateTime(targetMonth.year, targetMonth.month + 1, 0);

    // 1. ANCHOR: The Start Date
    DateTime gridStart = habit.startDate.isAfter(monthStart) 
        ? DateTime(habit.startDate.year, habit.startDate.month, habit.startDate.day)
        : monthStart;

    // 2. THE MATH: Total squares for the remainder of the month
    final daysInWindow = monthEnd.difference(gridStart).inDays + 1;
    final int totalContractSquares = (daysInWindow * (goal / 7)).floor();

    // 3. DATA: Monthly completions
    final completions = habit.completedDays.where((d) => 
      d.year == targetMonth.year && d.month == targetMonth.month
    ).toList();
    
    // Sort them so we process chronologically
    completions.sort((a, b) => a.compareTo(b));

    List<HabitSquareStatus> results = [];
    int completionsUsed = 0;

    // 4. THE FILL: 
    // We process week-by-week to find how many greens go in each row
    DateTime currentWeekStart = gridStart;
    while (currentWeekStart.isBefore(monthEnd)) {
      DateTime weekEnd = currentWeekStart.add(const Duration(days: 6));
      
      // Count how many times you actually did it in this specific 7-day window
      int countInWeek = completions.where((d) => 
        (d.isAfter(currentWeekStart) || d.isAtSameMomentAs(currentWeekStart)) && 
        (d.isBefore(weekEnd) || d.isAtSameMomentAs(weekEnd))
      ).length;

      // Fill the week's goal
      for (int i = 0; i < goal; i++) {
        // If we still have slots left in our "Total Contract"
        if (results.length < totalContractSquares) {
          if (i < countInWeek) {
            results.add(HabitSquareStatus.completed);
            completionsUsed++;
          } else {
            results.add(HabitSquareStatus.empty);
          }
        }
      }
      currentWeekStart = currentWeekStart.add(const Duration(days: 7));
    }

    // 5. THE OVERFLOW: Anything left over is Gold
    int overflow = completions.length - completionsUsed;
    if (overflow > 0) {
      results.addAll(List.filled(overflow, HabitSquareStatus.overflow));
    }

    return results;
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