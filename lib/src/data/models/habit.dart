import 'package:improov/src/core/constants/app_colors.dart';
import 'package:improov/src/data/enums/priority.dart';
import 'package:isar/isar.dart';

part 'habit.g.dart';

@collection
class Habit {
  //habit id
  Id id = Isar.autoIncrement;

  //habit name
  late String name;

  //habit description
  String? description;

  bool isHabitMode = true;

  //starting time
  DateTime startDate = DateTime.now();

  //habit goal
  int goalDaysPerWeek = 7;

  //habit priority
  @enumerated
  Priority priority = Priority.low;

  //habit reminder
  DateTime? reminderTime;

  //completed days
  List<DateTime> completedDays = [];

  //for sovereign overlap
  List<int> preferredDays = [];

  //sort weight (heigher number = higher on the list)
  @Index()
  double sortScore = 0.0;

  //heatmap past glory
  bool isArchived = false;

  //streak system
  int currentStreak = 0;
  int bestStreak = 0;

  //last monday
  DateTime? lastResetDate;

  //visual identtity of the habit
  int colorHex = AppColors.slayGreen.toARGB32();

  /*      L O G I C - G E T T E R S    */

  int get calculateStreak {
    if (completedDays.isEmpty) return 0;

    final dates = completedDays
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (!dates.contains(today) && !dates.contains(yesterday)) return 0;

    int streak = 0;
    DateTime checkDate = dates.contains(today) ? today : yesterday;

    while (dates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    return streak;
  }

  bool get isCompleted {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return completedDays.any((date) => 
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day
    );
  }

  //calculate this week's progress compared to monday reset
  int get weeklyCount {
    final now = DateTime.now();
    // Find Monday
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = DateTime(monday.year, monday.month, monday.day);

    return completedDays.where((date) {
      final checkDate = DateTime(date.year, date.month, date.day);

      return checkDate.isAtSameMomentAs(startOfWeek) || checkDate.isAfter(startOfWeek);
    }).length;
  }

  //is the goal met?
  bool get isGoalMet => weeklyCount >= goalDaysPerWeek;

  //pollution factor for heatmap
  double get densityValue {
    double count = weeklyCount.toDouble();
    double goal = goalDaysPerWeek.toDouble();

    if (goal == 0) return 0.0;
    return count/goal;
  }

  int get realStreak => calculateStreak;

  int get displayedStreak {
    return realStreak;
  }

  // H E A T M A P 
  @ignore
  Map<DateTime, int> get completionMap {
    Map<DateTime, int> dataset = {};
    
    for (var date in completedDays) {
      // Standardize to midnight for the heatmap key
      final cleanDate = DateTime(date.year, date.month, date.day);
      dataset[cleanDate] = 1; // 1 = "Completed" color level
    }
    
    return dataset;
  }
}