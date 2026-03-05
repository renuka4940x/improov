import 'package:improov/src/data/enums/habit_status.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/presentation/streak/widgets/global_calendar/widgets/day_snapshot_habit.dart';

class HeatmapEngine {
  static Future<List<List<HabitSquareStatus>>> getWeeklyStatusChunks({
    required Habit habit,
    required DateTime targetMonth,
  }) async {
    final int goal = habit.goalDaysPerWeek;
    final DateTime monthStart = DateTime(targetMonth.year, targetMonth.month, 1);
    final DateTime monthEnd = DateTime(targetMonth.year, targetMonth.month + 1, 0);
    final habitStart = DateTime(habit.startDate.year, habit.startDate.month, habit.startDate.day);

    final completionDates = habit.completedDays
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();

    List<List<HabitSquareStatus>> allRows = [];

    // --- STEP 1: CALCULATE THE FIRST WEEK FRAGMENT ---
    int daysInFirstWeek = 8 - monthStart.weekday;
    if (daysInFirstWeek > 7) daysInFirstWeek = 7;
    if (daysInFirstWeek > monthEnd.day) daysInFirstWeek = monthEnd.day;

    allRows.add(_processWindow(
      start: monthStart,
      days: daysInFirstWeek,
      goal: goal,
      habitStart: habitStart,
      completions: completionDates,
    ));

    // --- STEP 2: CALCULATE THE MIDDLE AND END WEEKS ---
    DateTime currentPtr = monthStart.add(Duration(days: daysInFirstWeek));

    while (currentPtr.isBefore(monthEnd) || currentPtr.isAtSameMomentAs(monthEnd)) {
      int remainingInMonth = monthEnd.difference(currentPtr).inDays + 1;
      int windowSize = (remainingInMonth < 7) ? remainingInMonth : 7;

      allRows.add(_processWindow(
        start: currentPtr,
        days: windowSize,
        goal: goal,
        habitStart: habitStart,
        completions: completionDates,
      ));

      currentPtr = currentPtr.add(Duration(days: windowSize));
    }

    // Filter out any rows that ended up being empty (before habit started)
    return allRows.where((row) => row.isNotEmpty).toList();
  }

  static List<HabitSquareStatus> _processWindow({
    required DateTime start,
    required int days,
    required int goal,
    required DateTime habitStart,
    required Set<DateTime> completions,
  }) {
    List<HabitSquareStatus> results = [];
    int count = 0;
    int activeDays = 0;

    for (int i = 0; i < days; i++) {
      DateTime checkDay = start.add(Duration(days: i));
      if (!checkDay.isBefore(habitStart)) {
        activeDays++;
        if (completions.contains(checkDay)) {
          count++;
        }
      }
    }

    // If the habit hasn't started in this window at all, return empty row
    if (activeDays == 0) return [];

    // Goal for this specific fragment is capped by active days
    int adjustedGoal = (goal > activeDays) ? activeDays : goal;

    // Fill contract squares
    for (int i = 0; i < adjustedGoal; i++) {
      results.add(i < count ? HabitSquareStatus.completed : HabitSquareStatus.empty);
    }

    // Interleave Gold (Overflow)
    if (count > adjustedGoal) {
      int overflowCount = count - adjustedGoal;
      for (int i = 0; i < overflowCount; i++) {
        results.add(HabitSquareStatus.overflow);
      }
    }

    return results;
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