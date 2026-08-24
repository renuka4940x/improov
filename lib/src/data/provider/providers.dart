import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:improov/src/data/database/isar_service.dart';

part 'providers.g.dart'; 

@riverpod
Future<IsarService> isarDatabase(Ref ref) async {
  return await IsarService.init();
}