import 'package:flutter/material.dart';
import 'package:improov/src/data/database/isar_service.dart';
import 'package:improov/src/data/models/task.dart'; // Your Isar service

class TaskProvider extends ChangeNotifier {
  final IsarService _isarService;

  TaskProvider(this._isarService);

  DateTime stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<List<Task>> getTasksForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final allTasks = await _isarService.queryTasksByDateRange(start, end);
  
    return allTasks.where((t) {
      if (t.dueDate == null) return false;
      final taskDate = t.dueDate!.toLocal();
      return taskDate.year == date.year && 
        taskDate.month == date.month && 
        taskDate.day == date.day;
    }).toList();
  }

  Future<List<DateTime>> getTaskDatesForMonth(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final allTasks = await _isarService.queryTasksByDateRange(start, end);

    //using a Map to ensure each YYYY-MM-DD has only one unique DateTime entry
    final Map<String, DateTime> uniqueDates = {};

    for (var t in allTasks.where((t) => t.isCompleted == false)) {
      final dueDate = (t.dueDate ?? DateTime.now()).toLocal();
      final normalized = stripTime(dueDate);
      final key = "${normalized.year}-${normalized.month}-${normalized.day}";
      
      uniqueDates[key] = normalized;
    }

    return uniqueDates.values.toList();
  }
}