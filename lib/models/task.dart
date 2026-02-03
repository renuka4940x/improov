import 'package:improov/models/enums/priority.dart';
import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  //task id
  Id id = Isar.autoIncrement;

  //task name
  late String title;

  //task descrpition
  String? description;

  //due date
  DateTime? dueDate;

  //task priority
  @enumerated
  Priority priority = Priority.low;

  //task reminder
  DateTime? reminderTime;

  //is completed or not
  bool isCompleted = false;

  late DateTime createdAt;
}