import 'dart:async';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:improov/src/data/models/task/task.dart';
import 'package:improov/src/data/models/app_settings/global_stats.dart';
import 'package:improov/src/data/enums/priority.dart';
import 'package:improov/src/data/provider/providers.dart';
import 'package:isar/isar.dart';

import 'package:improov/dataconnect_generated/generated.dart';

part 'task_notifier.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  FutureOr<List<Task>> build() async {
    final service = await ref.watch(isarDatabaseProvider.future);
    
    // Initialize stats if they don't exist
    await _initializeStats(service.db);
    
    return _fetchAndSortTasks(service.db);
  }

  // --- PRIVATE HELPER METHODS ---

  Future<void> _initializeStats(Isar isar) async {
    final stats = await isar.globalStats.get(0);
    if (stats == null) {
      await isar.writeTxn(() => isar.globalStats.put(GlobalStats()));
    }
  }

  Future<List<Task>> _fetchAndSortTasks(Isar isar) async {
    final fetchedTasks = await isar.tasks.where().findAll();

    return fetchedTasks..sort((a, b) {
      // Completion status
      if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;

      // Priority
      final priorityMap = {Priority.high: 0, Priority.medium: 1, Priority.low: 2};
      int valA = priorityMap[a.priority] ?? 3;
      int valB = priorityMap[b.priority] ?? 3;
      if (valA != valB) return valA.compareTo(valB);

      // Due Date
      return (a.dueDate ?? DateTime(2100)).compareTo(b.dueDate ?? DateTime(2100));
    });
  }

  // --- C R U D  O P E R A T I O N S ---

  //C R E A T E
  Future<void> addTask(String name, {
    String? description = "",
    Priority priority = Priority.low,
    DateTime? dueDate,
    DateTime? reminderTime,
  }) async {
    final service = await ref.read(isarDatabaseProvider.future);
    final finalDate = dueDate ?? DateTime.now()
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);

    final newTask = Task()
      ..title = name
      ..description = description
      ..dueDate = finalDate
      ..priority = priority
      ..isCompleted = false
      ..createdAt = DateTime.now()
      ..reminderTime = reminderTime;

    await service.db.writeTxn(() => service.db.tasks.put(newTask));
    
    //refreshes the state
    ref.invalidateSelf(); 

    //firebase sync
    try {
      await ExampleConnector.instance.createTask(
        id: newTask.uuid,
        name: name,
        description: description ?? "",
        dueDate: Timestamp.fromJson(finalDate.toUtc().toIso8601String()),
        isCompleted: false,
        createdAt: Timestamp.fromJson(newTask.createdAt.toUtc().toIso8601String()),
        priority: priority.name,
      ).execute();
      debugPrint("☁️ Successfully created task in the cloud!");
    } catch (e) {
      debugPrint("☁️ Create Task Sync Error (Create Task): $e");
    }
  }

  //U P D A T E: task completion
  Future<void> updateTaskCompletion(int id, bool isCompleted) async {
    final service = await ref.read(isarDatabaseProvider.future);
    Task? targetTask;

    await service.db.writeTxn(() async {
      final task = await service.db.tasks.get(id);
      final stats = await service.db.globalStats.get(0) ?? GlobalStats();

      if (task != null) {
        if (isCompleted && !task.isCompleted) {
          stats.totalTasksCompleted += 1;
        }

        else if (!isCompleted && task.isCompleted) {
          stats.totalTasksCompleted -= 1;
        }

        task.isCompleted = isCompleted;
        await service.db.tasks.put(task);
        await service.db.globalStats.put(stats);
        targetTask = task;
      }
    });

    ref.invalidateSelf();

    // Firebase Sync - Update Task Completion
    if (targetTask != null) {
      try {
        await ExampleConnector.instance.updateTask(
          id: targetTask!.uuid,
          name: targetTask!.title,
          description: targetTask!.description ?? "",
          dueDate: Timestamp.fromJson(targetTask!.dueDate!.toUtc().toIso8601String()),
          isCompleted: isCompleted,
          priority: targetTask!.priority.name,
        ).execute();
        debugPrint("☁️ Successfully updated task completion in cloud!");
      } catch (e) {
        debugPrint("☁️ Sync Error (Task Completion): $e");
      }
    }
  }

  //D E L E T E
  Future<void> deleteTask(int id) async {
    final service = await ref.read(isarDatabaseProvider.future);

    final taskToDelete = await service.db.tasks.get(id);
    
    if (taskToDelete != null) {
      await service.db.writeTxn(() => service.db.tasks.delete(id));
      ref.invalidateSelf();

      try {
        await ExampleConnector.instance.deleteTask(
          id: taskToDelete.uuid,
        ).execute();
        debugPrint("☁️ Successfully deleted task in the cloud!");
      } catch (e) {
        debugPrint("☁️ Sync Error (Delete Task): $e");
      }
    }
  }

  //U P D A T E: handleSave
  Future<void> handleSaveTask({
    Task? existingTask,
    required String title,
    required String description,
    required Priority priority,
    required DateTime dueDate,
    DateTime? reminder,
  }) async {
    if (existingTask != null) {
      final service = await ref.read(isarDatabaseProvider.future);
      await service.db.writeTxn(() async {
        existingTask.title = title;
        existingTask.description = description;
        existingTask.priority = priority;
        existingTask.dueDate = dueDate;
        existingTask.reminderTime = reminder;
        await service.db.tasks.put(existingTask);
      });
      ref.invalidateSelf();

      // Firebase Sync - Update Task Details
      try {
        await ExampleConnector.instance.updateTask(
          id: existingTask.uuid,
          name: title,
          description: description,
          dueDate: Timestamp.fromJson(dueDate.toUtc().toIso8601String()),
          isCompleted: existingTask.isCompleted,
          priority: priority.name,
        ).execute();
        debugPrint("☁️ Successfully updated task details in cloud!");
      } catch (e) {
        debugPrint("☁️ Sync Error (Update Task): $e");
      }
    } 
    
    else {
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