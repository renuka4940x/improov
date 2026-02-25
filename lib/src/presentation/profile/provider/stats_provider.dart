import 'package:flutter/material.dart';
import 'package:improov/src/features/habits/provider/habit_database.dart';
import 'package:improov/src/features/tasks/provider/task_database.dart';

class StatsProvider extends ChangeNotifier{
  final HabitDatabase habitDb;
  final TaskDatabase taskDb;

  int _bestStreak = 0;
  int _totalTasksCompleted = 0;

  int get bestStreak => _bestStreak;
  int get totalTasksCompleted => _totalTasksCompleted;

  StatsProvider(this.habitDb, this.taskDb) {
    habitDb.onUpdate.listen((_) => refreshStats());
    taskDb.onUpdate.listen((_) => refreshStats());

    refreshStats();
  }

  Future<void> refreshStats() async {
    _bestStreak = await habitDb.getGlobalBestStreak();
    _totalTasksCompleted = await taskDb.getTotalTasksCompleted();

    notifyListeners();
  }
}