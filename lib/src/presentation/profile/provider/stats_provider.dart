import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart';
// Note: You can likely remove the isar/database imports here!

part 'stats_provider.g.dart';

@riverpod
Future<Map<String, int>> globalStats(GlobalStatsRef ref) async {
  final habitsAsync = ref.watch(habitNotifierProvider);
  final tasksAsync = ref.watch(taskNotifierProvider);

  final habits = habitsAsync.value ?? [];
  final tasks = tasksAsync.value ?? [];

  int bestStreak = 0;
  if (habits.isNotEmpty) {
    bestStreak = habits.fold<int>(0, (max, h) => h.bestStreak > max ? h.bestStreak : max);
  }

  final totalTasks = tasks.length; 

  return {
    'bestStreak': bestStreak,
    'totalTasksCompleted': totalTasks,
  };
}