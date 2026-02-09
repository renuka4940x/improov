import 'package:flutter/cupertino.dart';
import 'package:improov/src/core/constants/app_colors.dart';
import 'package:improov/src/data/database/isar_service.dart';
import 'package:improov/src/data/models/app_settings.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:isar/isar.dart';

import '../../../data/enums/priority.dart';

class HabitDatabase extends ChangeNotifier {
  final isar = IsarService().db;

  /*        S E T U P       */

  // save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*        C R U D - O P E R A T I O NS        */

  //list of habits
  final List<Habit> currentHabits = [];

  // C R E A T E
  Future<void> addHabit(
      String habitName, 
      bool isHabitMode, {
      String? description = "",
      DateTime? startDate,
      Priority priority = Priority.low,
      int goalDays = 3,
      DateTime? reminderTime,
      int? colorHex
    }) async {
      // if dueDate is null -> use today's date
      final now = DateTime.now();
      final today = startDate ?? DateTime(now.year, now.month, now.day);

      //create a new habit
      final newHabit = Habit()
        ..name = habitName
        ..isHabitMode = isHabitMode
        ..description = description
        ..startDate = today
        ..priority =priority
        ..reminderTime= reminderTime
        ..goalDaysPerWeek = goalDays
        ..colorHex = colorHex ?? AppColors.slayGreen.toARGB32()
        ..completedDays = [];

      //save to db
      await isar.writeTxn(() => isar.habits.put(newHabit));

      //re-read from db
      readHabits();
    }

  // R E A D
  Future<void> readHabits() async {
    //make sure isar is open
    if (Isar.instanceNames.isEmpty){
      return;
    } 

    //fetch all habits from db
    final fetechedHabits = await isar.habits.where().findAll();

    final now = DateTime.now();
    final daysLeftInWeek = 8 - now.weekday;

    fetechedHabits.sort((a,b) {
      final bool aDone = a.isCompleted;
      final bool bDone = b.isCompleted;

      if (aDone != bDone) { 
        return a.isCompleted ? 1 : -1;
      }

      //pressure score
      double getPressure(Habit h) {
        //if goal is met pressure is 0
        if (h.weeklyCount >= h.goalDaysPerWeek) return 0.0;

        int needs = h.goalDaysPerWeek - h.weeklyCount;

        //if needs > daysleft, score goes above 1.0 (cirtical
        return needs / daysLeftInWeek.toDouble();
      }

      double pressureA = getPressure(a);
      double pressureB = getPressure(b);

      if (pressureA != pressureB) {
        return pressureB.compareTo(pressureA);
      }
  
      //sort them based on priority
      final priorityMap = {
        Priority.high: 0,
        Priority.medium: 1,
        Priority.low: 2,
      };

      int valA = priorityMap[a.priority] ?? 3;
      int valB = priorityMap[b.priority] ?? 3;

      return valA.compareTo(valB);
    });

    //give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetechedHabits);

    //update UI
    notifyListeners();
  }

  // U P D A T E - habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //find the specific habit
    final habit = await isar.habits.get(id);
    final now = DateTime.now();

    //update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        final today = DateTime(now.year, now.month, now.day);

        //check if today already exists in the list
        final alreadyExists = habit.completedDays.any((date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day
        );
        //if habit is completed -> add the current date to the completedDays list
        if (isCompleted && !alreadyExists) {

          //add current date if it's not already in the list
          habit.completedDays.add(today);
        } 

        //if habit is not completed -> remove the current date from the list
        else if (!isCompleted){
          //remove the current date if the habit is marked as not completed
          habit.completedDays.removeWhere((date) =>
            date.year == now.year &&
            date.month == now.month &&
            date.day == now.day
          );
        }

        //save the updated habits back to the db
        await isar.habits.put(habit);
      });
    }

    //re-read from db
    readHabits();
  }

  // U P D A T E - edit habit 
  Future<void> updateHabit(
      int id, 
      String newName,
      String newDesc,
      Priority newPriority,
      int newGoal,
      DateTime? newReminderTime,
      int newColor,
    ) async {
    //find the specific habit
    final habit = await isar.habits.get(id);

    //update habit
    if(habit !=null) {
      //update field
      await isar.writeTxn(()async {
        habit.name = newName;
        habit.description = newDesc;
        habit.priority = newPriority;
        habit.goalDaysPerWeek = newGoal;
        habit.reminderTime = newReminderTime;
        habit.colorHex = newColor;

        //save updated habit back to the db
        await isar.habits.put(habit);
      });
    }

    //re-read from db
    readHabits();
  }

  // D E L E T E
  Future<void> deleteHabit(int id) async {
    //perform the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    //re-read from db
    readHabits();
  }

  //handles save habits
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
    //if colorHex is null we assign slayGreen
    final finalColor = colorHex ?? AppColors.slayGreen.toARGB32();
    if (existingHabit != null ) {
      //update habit
      await updateHabit(
        existingHabit.id, 
        name, 
        description, 
        priority, 
        goal, 
        reminderTime,
        finalColor,
      );
    } else {
      await addHabit(
        //create habit
        name,
        true,
        description: description,
        priority: priority,
        goalDays: goal,
        startDate: startDate,
        reminderTime: reminderTime,
        colorHex: finalColor,
      );
    }
  }
}
