import 'package:improov/src/data/models/app_settings.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/data/models/task.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static late Isar _isar;

  //initializa the database
  static Future<void> init() async {
    final dir = await getApplicationCacheDirectory();

    //check for open instances
    if(Isar.instanceNames.isEmpty) {
      _isar = await Isar.open(
        [TaskSchema, HabitSchema, AppSettingsSchema], 
        directory: dir.path,
        inspector: false,
      );
    } else {
      _isar = Isar.getInstance()!;
    }
  }

  Isar get db => _isar;
}