import 'package:improov/src/data/enums/priority.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@collection
class Task {
  //task id
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String uuid = const Uuid().v4();

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

  //subtask
  List<Subtask> subtasks = [];
}

//embedded Subtask model
@embedded
class Subtask {
  //easily identify which subtask the user tapped
  String uuid = const Uuid().v4();
  
  String? title;
  
  bool isCompleted = false;
}
