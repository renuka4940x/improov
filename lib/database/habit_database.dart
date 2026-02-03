import 'package:flutter/cupertino.dart';
import 'package:improov/models/app_settings.dart';
import 'package:improov/models/habit.dart';
import 'package:improov/models/task.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/enums/priority.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*        S E T U P       */

  // I N I T I A L I Z E - D A T A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
      TaskSchema,
    ], 
    directory: dir.path);
  }

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
      String habitName, {
      String? description = "", 
      Priority priority = Priority.low,
      int goalDays = 3,
      DateTime? reminderTime,
    }) async {

      //create a new habit
      final newHabit = Habit()
        ..name = habitName
        ..description = description
        ..priority =priority
        ..reminderTime= reminderTime
        ..goalDaysPerWeek = goalDays
        ..completedDays = [];

      //save to db
      await isar.writeTxn(() => isar.habits.put(newHabit));

      //re-read from db
      readHabits();
    }

  // R E A D
  Future<void> readHabits() async {
    //fetch all habits from db
    final fetechedHabits = await isar.habits.where().findAll();

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

    //update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
      //if habit is completed -> add the current date to the completedDays list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          //today
          final today = DateTime.now();

          //add current date if it's not already in the list
          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        } 

        //if habit is not completed -> remove the current date from the list
        else {
          //remove the current date if the habit is marked as not completed
          habit.completedDays.removeWhere((date) =>
            date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day
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
}
