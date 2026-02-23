import 'package:improov/src/data/enums/habit_status.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/features/streak/widgets/global_calendar/widgets/day_snapshot.dart';

class HeatmapEngine {
  static Future<List<HabitSquareStatus>> getLinearStatuses({
    required Habit habit,
    required DateTime targetMonth,
  }) async {
    final int goal = habit.goalDaysPerWeek;
    final DateTime monthStart = DateTime(targetMonth.year, targetMonth.month, 1);
    final DateTime monthEnd = DateTime(targetMonth.year, targetMonth.month + 1, 0);

    //start on habit start date or month start
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
      //determine the end of the current habit week
      int daysUntilMonday = 8 - currentWeekStart.weekday;
      if (daysUntilMonday > 7) daysUntilMonday = 7;

      DateTime weekEnd = currentWeekStart.add(Duration(days: daysUntilMonday - 1));

      //
      if (weekEnd.isAfter(monthEnd)) {
        weekEnd = DateTime(monthEnd.year, monthEnd.month, monthEnd.day);
      }

      //recalculate the actual days available in this final fragment
      int daysInThisWindow = weekEnd.difference(currentWeekStart).inDays + 1;

      //the Adjusted Goal (The "Tail")
      int adjustedGoal = (goal > daysInThisWindow) ? daysInThisWindow : goal;

      int countInWeek = 0;
      for (int i = 0; i < daysInThisWindow; i++) {
        DateTime checkDay = currentWeekStart.add(Duration(days: i));
        if (completionDates.contains(DateTime(checkDay.year, checkDay.month, checkDay.day))) {
          countInWeek++;
        }
      }

      //fill the Contract
      for (int i = 0; i < adjustedGoal; i++) {
        if (i < countInWeek) {
          contractSquares.add(HabitSquareStatus.completed);
        } else {
          contractSquares.add(HabitSquareStatus.empty);
        }
      }

      //track Overflow (Gold)
      if (countInWeek > adjustedGoal) {
        totalOverflow += (countInWeek - adjustedGoal);
      }

      //move to next week
      currentWeekStart = weekEnd.add(const Duration(days: 1));
    }

    return [
      ...contractSquares,
      ...List.filled(totalOverflow, HabitSquareStatus.overflow)
    ];
  }

  static Map<int, DaySnapshot> generateGlobalSnapshot({
    required List<Habit> habits,
    required DateTime targetMonth,
  }) {
    final Map<int, DaySnapshot> snapshots = {};
    
    //get total days in the month
    final lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;

    for (int i = 1; i <= lastDay; i++) {
      final checkDate = DateTime(targetMonth.year, targetMonth.month, i);
      
      //which habits have this day in their completedDays list?
      final completedToday = habits.where((h) {
        return h.completedDays.any((d) => 
          d.year == checkDate.year && 
          d.month == checkDate.month && 
          d.day == checkDate.day
        );
      }).toList();

      //did any habit start today?
      final isOrigin = habits.any((h) => 
          h.startDate.year == checkDate.year && 
          h.startDate.month == checkDate.month && 
          h.startDate.day == checkDate.day
      );

      snapshots[i] = DaySnapshot(
        completedCount: completedToday.length,
        hasOrigin: isOrigin,
        completedHabits: completedToday,
      );
    }
    
    return snapshots;
  }
}