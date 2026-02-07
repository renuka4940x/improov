import 'package:flutter/cupertino.dart';
import 'package:improov/src/data/enums/priority.dart';
import 'package:isar/isar.dart';

import '../../../data/models/task.dart';

class TaskDatabase extends ChangeNotifier {
  final Isar isar;
  //getting isar instance from habit_db
  TaskDatabase(this.isar);

  //list of tasks
  final List<Task> currentTasks = [];

  /*             C R U D              */

  // C R E A T E
  Future<void> addTask(
    String taskName, {
    String? description = "",
    Priority priority = Priority.low,
    DateTime? dueDate,
    DateTime? reminderTime,
  }) async {

    // if dueDate is null -> use today's date
    final now = DateTime.now();
    final finalDate = dueDate ?? DateTime(now.year, now.month, now.day);

    //create new task
    final newTask = Task()
      ..title = taskName
      ..description = description
      ..dueDate = finalDate
      ..priority = priority
      ..isCompleted = false
      ..createdAt = DateTime.now()
      ..reminderTime = reminderTime;

    //save to db
    await isar.writeTxn(() => isar.tasks.put(newTask));

    //re-read from db
    readTask();
  }

  // R E A D
  Future<void> readTask() async {
    //make sure isar is open
    if (Isar.instanceNames.isEmpty) return;
    
    //fetch all tasks from db
    final fetchedTasks = await isar.tasks.where().findAll();

    //sort
    fetchedTasks.sort((a, b) {
      //incomplete lowest
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      //priority
      final priorityMap = {
        Priority.high: 0,
        Priority.medium: 1,
        Priority.low: 2,
      };
      int valA = priorityMap[a.priority] ?? 3;
      int valB = priorityMap[b.priority] ?? 3;

      if(valA != valB) {
        return valA.compareTo(valB);
      }

      //due date (earliest first)
      DateTime dateA = a.dueDate ?? DateTime(2100);
      DateTime dateB = b.dueDate ?? DateTime(2100);
      return dateA.compareTo(dateB);
    });

    //give to currentTasks
    currentTasks.clear();
    currentTasks.addAll(fetchedTasks);

    //update UI
    notifyListeners();
  }

  // U P D A T E - task completion
  Future<void> updateTaskCompletion(int id, bool isCompleted) async {
    //find specific task
    final task = await isar.tasks.get(id);

    //update completion logic
    if(task != null) {
      //flip the status
      task.isCompleted = isCompleted;

      //save to db
      await isar.writeTxn(() async { 
        await isar.tasks.put(task);
      });
      
      //re-read from db
      readTask();
    }
  }

  // U P D A T E - update task
  Future<void> updateTask(
    int id,
    String newTitle,
    String newDesc,
    Priority newPriority,
    DateTime newDueDate,
    DateTime? newReminderTime,
  ) async {
    //find specific task
    final task = await isar.tasks.get(id);

    //update task deatils
    if (task != null) {
      //update field
      await isar.writeTxn(() async {
        task.title = newTitle;
        task.description = newDesc;
        task.priority = newPriority;
        task.dueDate = newDueDate;
        task.reminderTime = newReminderTime;

      //save updated task back to the db
      await isar.tasks.put(task);
      });
    }

    //re-read from db
    readTask();
  }

  // D E L E T E
  Future<void> deleteTask(int id) async {
    //perform the delete
    await isar.writeTxn(() async{
      await isar.tasks.delete(id);
    });

    //re-read from db
    readTask();
  }

  //Handle Task Save
  Future<void> handleSaveTask({
    Task? existingTask,
    required String title,
    required String description,
    required Priority priority,
    required DateTime dueDate,
    DateTime? reminder,
  }) async {
    if (existingTask != null) {
      // Update logic
      await updateTask(
        existingTask.id, 
        title, 
        description, 
        priority, 
        dueDate, 
        reminder
      );
    } else {
      // Create logic
      await addTask(
        title, 
        description: description, 
        priority: priority,
        dueDate: dueDate, 
        reminderTime: reminder
      );
    }
  }
}