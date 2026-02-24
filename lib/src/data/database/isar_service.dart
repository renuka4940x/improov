import 'package:improov/src/data/models/app_settings.dart';
import 'package:improov/src/data/models/global_stats.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/data/models/task.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static late Isar _isar;

  static Future<void> init() async {
    final dir = await getApplicationCacheDirectory();

    if(Isar.instanceNames.isEmpty) {
      _isar = await Isar.open(
        [TaskSchema, HabitSchema, AppSettingsSchema, GlobalStatsSchema], 
        directory: dir.path,
        inspector: false,
      );
    } else {
      _isar = Isar.getInstance()!;
    }
  }

  static Isar get db => _isar;
}