import 'package:improov/src/data/models/app_settings.dart';
import 'package:improov/src/data/models/global_stats.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/data/models/task.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  final Isar db;

  // Private constructor
  IsarService._(this.db);

  // This creates the ONE instance to be passed to all providers
  static Future<IsarService> init() async {
    final dir = await getApplicationDocumentsDirectory();

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    
    final isar = Isar.getInstance('improov_db') ?? await Isar.open(
      [TaskSchema, HabitSchema, AppSettingsSchema, GlobalStatsSchema],
      directory: dir.path,
      name: 'improov_db',
      inspector: false,
    );
    
    return IsarService._(isar);
  }

  Future<List<Task>> queryTasksByDateRange(DateTime start, DateTime end) async {
    return await db.tasks
      .filter()
      .dueDateBetween(start, end)
      .findAll();
  }
}