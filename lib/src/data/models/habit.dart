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
    // Create a clean "Monday at 00:00:00"
    final startOfWeek = DateTime(monday.year, monday.month, monday.day);

    return completedDays.where((date) {
      // Create a clean "Completion Date at 00:00:00"
      final checkDate = DateTime(date.year, date.month, date.day);
      
      // Check if it's the same day as Monday or after
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

  int get displayedStreak {
    //if they hit their goal, show current streak + this week
    if (isCompleted) {
      return currentStreak + 1;
    }
    //else show the completed past weeks
    return currentStreak;
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