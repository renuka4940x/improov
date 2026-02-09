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

  //motivation factor
  int bestStreak = 0;

  //visual identtity of the habit
  int colorHex = AppColors.slayGreen.toARGB32();

  /*      L O G I C - G E T T E R S    */

  bool get isCompleted {
    final today = DateTime.now();
    return completedDays.any((date) => 
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day
    );
  }

  //calculate this week's progress compared to monday reset
  int get weeklyCount {
    final now = DateTime.now();
    //monday of current streak
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final resetPoint = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return completedDays.where((date) => date.isAfter(resetPoint)).length;
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
}