import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendar_month_provider.g.dart';

@riverpod
class CalendarMonth extends _$CalendarMonth {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  void changeMonth(int increment) {
    state = DateTime(state.year, state.month + increment, 1);
  }

  void resetToCurrent() {
    final now = DateTime.now();
    state = DateTime(now.year, now.month, 1);
  }
}