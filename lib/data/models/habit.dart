import 'package:improov/data/models/enums/priority.dart';
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

  //habit goal
  int goalDaysPerWeek = 7;

  //habit priority
  @enumerated
  Priority priority = Priority.low;

  //habit reminder
  DateTime? reminderTime;

  //completed days
  List<DateTime> completedDays = [];
}