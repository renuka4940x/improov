import 'package:improov/src/data/models/app_settings/global_stats.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart';
import 'package:improov/src/data/provider/providers.dart';

part 'stats_provider.g.dart';

@riverpod
Future<Map<String, int>> globalStats(GlobalStatsRef ref) async {
  final habitsAsync = ref.watch(habitNotifierProvider);
  final habits = habitsAsync.value ?? [];

  int bestStreak = 0;
  if (habits.isNotEmpty) {
    bestStreak = habits.fold<int>(0, (max, h) => h.bestStreak > max ? h.bestStreak : max);
  }

  final service = await ref.read(isarDatabaseProvider.future);

  final stats = await service.db.globalStats.get(0);
  final totalTasksDone = stats?.totalTasksCompleted ?? 0;

  return {
    'bestStreak': bestStreak,
    'totalTasksCompleted': totalTasksDone,
  };
}