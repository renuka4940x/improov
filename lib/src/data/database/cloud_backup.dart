import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/material.dart';
import 'package:improov/dataconnect_generated/generated.dart';
import 'package:improov/src/data/models/habit/habit.dart';
import 'package:improov/src/data/models/task/task.dart';
import 'package:improov/src/data/provider/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

Future<void> syncAllLocalDataToCloud(Ref ref) async {
    debugPrint("🔄 Starting Initial Cloud Sync...");
    final service = await ref.read(isarDatabaseProvider.future);
    
    // Fetch everything from the local device
    final allHabits = await service.db.habits.where().findAll();
    final allTasks = await service.db.tasks.where().findAll();

    // Push Habits
    int habitsSynced = 0;
    for (final habit in allHabits) {
      try {
        await ExampleConnector.instance.createHabit(
          id: habit.uuid,
          name: habit.name,
          description: habit.description ?? "",
          isHabitMode: habit.isHabitMode,
          startDate: Timestamp.fromJson(habit.startDate.toUtc().toIso8601String()),
          goalDaysPerWeek: habit.goalDaysPerWeek,
          priority: habit.priority.name,
          colorHex: habit.colorHex.toDouble(),
          isArchived: habit.isArchived,
        ).execute();
        
        if (habit.completedDays.isNotEmpty) {
           await ExampleConnector.instance.updateHabitCompletion(
             id: habit.uuid,
             currentStreak: habit.currentStreak,
             bestStreak: habit.bestStreak,
             completedDays: habit.completedDays.map((d) => d.toIso8601String()).toList(),
           ).execute();
        }
        habitsSynced++;
      } catch (e) {
        debugPrint("⚠️ Skipped Habit ${habit.name}: $e");
      }
    }

    // Push Tasks 
    int tasksSynced = 0;
    for (final task in allTasks) {
      try {
        await ExampleConnector.instance.createTask(
          id: task.uuid,
          name: task.title,
          description: task.description ?? "",
          dueDate: Timestamp.fromJson(task.dueDate!.toUtc().toIso8601String()),
          isCompleted: task.isCompleted,
          createdAt: Timestamp.fromJson(task.createdAt.toUtc().toIso8601String()),
          priority: task.priority.name,
        ).execute();
        tasksSynced++;
      } catch (e) {
        debugPrint("⚠️ Skipped Task ${task.title}: $e");
      }
    }

    debugPrint("✅ Sync Complete! Pushed $habitsSynced Habits and $tasksSynced Tasks.");
  }