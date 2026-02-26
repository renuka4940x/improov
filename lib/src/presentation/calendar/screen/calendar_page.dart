import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';
import 'package:improov/src/presentation/calendar/widgets/ui/calendar_view.dart';
import 'package:improov/src/presentation/calendar/widgets/ui/task_feed.dart';
import 'package:improov/src/presentation/calendar/widgets/util/task_audit_sheet.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {

  DateTime _selectedMonth = DateTime(
    DateTime.now().year, 
    DateTime.now().month, 
    1
  );
  DateTime _selectedDay = DateTime.now();

  void _changeMonth(int increment) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year, 
        _selectedMonth.month + increment, 1
      );
    });
  }

  DateTime stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1), 
                  icon: const Icon(Icons.chevron_left)
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${_selectedMonth.month} / ${_selectedMonth.year}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(onPressed: () => _changeMonth(1), icon: const Icon(Icons.chevron_right)),
              ],
            ),
          ),
        ),
      ),
      body: tasksAsync.when(
        data: (allTasks) {
          //filter data for the calendar
          final taskDates = allTasks
              .where((t) => 
                t.dueDate != null && 
                t.dueDate!.month == _selectedMonth.month && 
                t.dueDate!.year == _selectedMonth.year
              )
              .map((t) => stripTime(t.dueDate!))
              .toSet()
              .toList();

          //filter for the Task Feed
          final incompleteTasks = allTasks.where((t) => !t.isCompleted).toList();

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              CalendarView(
                targetMonth: _selectedMonth,
                daysWithTask: taskDates,
                selectedDay: _selectedDay,
                //get tasks for a specific tapped date
                getTasksForDate: (date) async { 
                  return allTasks.where((t) => 
                    t.dueDate != null && stripTime(t.dueDate!) == stripTime(date)
                  ).toList();
                },
                onDayTap: (date, tasks) async {
                  setState(() => _selectedDay = date);
                  await TaskAuditSheet.show(context, date, tasks);
                },
              ),
              const SizedBox(height: 20),
              TaskFeed(
                tasks: incompleteTasks,
                onToggle: (task) {
                  ref.read(taskNotifierProvider.notifier).updateTaskCompletion(task.id, !task.isCompleted);
                },
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }
}