import 'package:improov/src/data/models/global_stats.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:improov/src/data/provider/providers.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart';

part 'stats_provider.g.dart';

@riverpod
Future<Map<String, int>> globalStats(GlobalStatsRef ref) async {
  // 1. "Watch" the other notifiers. 
  // Whenever tasks or habits change, this whole function re-runs!
  ref.watch(taskNotifierProvider);
  ref.watch(habitNotifierProvider);

  final service = await ref.watch(isarDatabaseProvider.future);

  // 2. Fetch the data directly from Isar
  // Get total tasks completed from GlobalStats
  final statsRecord = await service.db.globalStats.get(0);
  final totalTasks = statsRecord?.totalTasksCompleted ?? 0;

  // Get the best streak from habits
  final bestHabit = await service.db.habits
      .where()
      .sortByBestStreakDesc()
      .findFirst();
  final bestStreak = bestHabit?.bestStreak ?? 0;

  // 3. Return as a simple map (or a dedicated class if you prefer)
  return {
    'bestStreak': bestStreak,
    'totalTasksCompleted': totalTasks,
  };
}