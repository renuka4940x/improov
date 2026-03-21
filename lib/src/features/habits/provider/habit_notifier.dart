import 'dart:async';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:improov/src/data/models/habit/habit.dart';
import 'package:improov/src/data/models/app_settings/app_settings.dart';
import 'package:improov/src/data/enums/priority.dart';
import 'package:improov/src/core/constants/app_colors.dart';
import 'package:improov/src/data/provider/providers.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:improov/dataconnect_generated/generated.dart';

part 'habit_notifier.g.dart';

@riverpod
class HabitNotifier extends _$HabitNotifier {
  final _uuid = const Uuid();

  @override
  FutureOr<List<Habit>> build() async {
    final service = await ref.watch(isarDatabaseProvider.future);
    
    await _saveFirstLaunchDate(service.db);
    await _checkWeeklyReset(service.db);

    return _fetchAndSortHabits(service.db);
  }

  // --- Private Helpers ---

  Future<void> _saveFirstLaunchDate(Isar isar) async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      await isar.writeTxn(() => isar.appSettings.put(AppSettings()..firstLaunchDate = DateTime.now()));
    }
  }

  Future<void> _checkWeeklyReset(Isar isar) async {
    final habits = await isar.habits.where().findAll();
    final now = DateTime.now();
    final startOfCurrentWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1));

    await isar.writeTxn(() async {
      for (var habit in habits) {
        if (habit.lastResetDate == null || habit.lastResetDate!.isBefore(startOfCurrentWeek)) {
          if (habit.weeklyCount >= habit.goalDaysPerWeek) {
            habit.currentStreak++;
            if (habit.currentStreak > habit.bestStreak) habit.bestStreak = habit.currentStreak;
          } else {
            habit.currentStreak = 0;
          }
          habit.lastResetDate = startOfCurrentWeek;
          await isar.habits.put(habit);
        }
      }
    });
  }

  List<Habit> _fetchAndSortHabits(Isar isar) {
    final habits = isar.habits.where().findAllSync();
    final now = DateTime.now();
    final daysLeftInWeek = 8 - now.weekday;

    return habits..sort((a, b) {
      if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;

      double getPressure(Habit h) {
        if (h.goalDaysPerWeek == 0) return 0.0;
        if (h.weeklyCount >= h.goalDaysPerWeek) return 0.0;
        return (h.goalDaysPerWeek - h.weeklyCount) / daysLeftInWeek.toDouble();
      }

      double pA = getPressure(a);
      double pB = getPressure(b);
      
      if (pA != pB) return pB.compareTo(pA);

      final priorityMap = {Priority.high: 0, Priority.medium: 1, Priority.low: 2};
      return (priorityMap[a.priority] ?? 3).compareTo(priorityMap[b.priority] ?? 3);
    });
  }

  // --- C R U D ---

  // C R E A T E
  Future<void> addHabit(String name, bool isHabitMode, {
    String? description = "",
    DateTime? startDate,
    Priority priority = Priority.low,
    int goalDays = 3,
    DateTime? reminderTime,
    int? colorHex,
  }) async {
    final service = await ref.read(isarDatabaseProvider.future);
    
    final newHabit = Habit()
      ..uuid = _uuid.v4()
      ..name = name
      ..isHabitMode = isHabitMode
      ..description = description
      ..startDate = startDate ?? DateTime.now()
      ..priority = priority
      ..reminderTime = reminderTime
      ..goalDaysPerWeek = goalDays
      ..colorHex = colorHex ?? AppColors.slayGreen.toARGB32()
      ..completedDays = [];

    // Save to ISAR
    await service.db.writeTxn(() => service.db.habits.put(newHabit));
    
    // Refresh UI
    ref.invalidateSelf();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        //send to data connect
        await ExampleConnector.instance.createHabit(
          id: newHabit.uuid,
          name: newHabit.name,
          description: newHabit.description ?? "",
          isHabitMode: newHabit.isHabitMode,
          startDate:Timestamp.fromJson(newHabit.startDate.toUtc().toIso8601String()),
          goalDaysPerWeek: newHabit.goalDaysPerWeek,
          priority: newHabit.priority.name, 
          colorHex: newHabit.colorHex.toDouble(), 
          isArchived: newHabit.isArchived,
        ).execute();
        
        debugPrint("Successfully created habit in the cloud!");
      }
    } catch (e) {
      debugPrint("Sync Error (Add): $e"); 
    }
  }

  // U P D A T E: habit completion
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final service = await ref.read(isarDatabaseProvider.future);
    final habit = await service.db.habits.get(id);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (habit != null) {
      await service.db.writeTxn(() async {
        if (isCompleted) {
          if (!habit.completedDays.any((d) => d.isAtSameMomentAs(today))) {
            habit.completedDays.add(today);
          }
        } else {
          habit.completedDays.removeWhere((d) => d.isAtSameMomentAs(today));
        }

        habit.currentStreak = habit.calculateStreak;
        if (habit.currentStreak > habit.bestStreak) habit.bestStreak = habit.currentStreak;
        
        await service.db.habits.put(habit);
      });
      
      ref.invalidateSelf();
      
      try {
        await ExampleConnector.instance.updateHabitCompletion(
          id: habit.uuid,
          currentStreak: habit.currentStreak,
          bestStreak: habit.bestStreak,
          completedDays: habit.completedDays
            .map((d) => d.toIso8601String()).toList(),
        ).execute();
        
        debugPrint("Successfully synced completion to cloud!");
      } catch (e) {
        debugPrint("Update Habit Completion Error (Completion): $e");
      }
    }
  }

  // U P D A T E: handle save (editing)
  Future<void> handleSaveHabit({
    Habit? existingHabit,
    required String name,
    required String description,
    required Priority priority,
    required int goal,
    required DateTime startDate,
    DateTime? reminderTime,
    int? colorHex,
  }) async {
    final service = await ref.read(isarDatabaseProvider.future);
    final finalColor = colorHex ?? AppColors.slayGreen.toARGB32();

    if (existingHabit != null) {
      await service.db.writeTxn(() async {
        existingHabit.name = name;
        existingHabit.description = description;
        existingHabit.priority = priority;
        existingHabit.goalDaysPerWeek = goal;
        existingHabit.reminderTime = reminderTime;
        existingHabit.colorHex = finalColor;
        await service.db.habits.put(existingHabit);
      });

      ref.invalidateSelf();
      
      try {
        await ExampleConnector.instance.updateHabit(
          id: existingHabit.uuid,
          name: name,
          description: description,
          goalDaysPerWeek: goal,
          priority: priority.name,
          colorHex: finalColor.toDouble(),
        ).execute();
        
        debugPrint("Successfully updated habit in the cloud!");
      } catch (e) {
        debugPrint("Update Habit Sync Error (Update): $e");
      }
    } else {
      await addHabit(
        name, 
        true, 
        description: description, 
        priority: priority, 
        goalDays: goal, 
        startDate: startDate, 
        reminderTime: reminderTime, 
        colorHex: finalColor
      );
    }
  }

  // D E L E T E
  Future<void> deleteHabit(int id) async {
    final service = await ref.read(isarDatabaseProvider.future);
    
    final habit = await service.db.habits.get(id);
    final String? remoteId = habit?.uuid;

    await service.db.writeTxn(() => service.db.habits.delete(id));
    ref.invalidateSelf();
    
    if (remoteId != null) {
      try {
         await ExampleConnector.instance.deleteHabit(
           id: remoteId
         ).execute();
         debugPrint("Successfully deleted habit in the cloud!");
       } catch (e) {
         debugPrint("Delete Habit Sync Error (Delete): $e");
       }
    }
  }
}