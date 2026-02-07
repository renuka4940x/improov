import 'package:improov/src/data/models/enums/priority.dart';
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

  bool get isCompleted {
    final today = DateTime.now();
    return completedDays.any((date) => 
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day
    );
  }
}