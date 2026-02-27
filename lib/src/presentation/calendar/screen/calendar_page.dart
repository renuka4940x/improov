import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:improov/src/core/util/provider/calendar_month_provider.dart';
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

  DateTime _selectedDay = DateTime.now();

  DateTime stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final selectedMonth = ref.watch(calendarMonthProvider);
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
                  onPressed: () => ref.read(calendarMonthProvider.notifier).changeMonth(-1),
                  icon: const Icon(Icons.chevron_left)
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${selectedMonth.month} / ${selectedMonth.year}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => ref.read(calendarMonthProvider.notifier).changeMonth(1),
                  icon: const Icon(Icons.chevron_right)
                ),
              ],
            ),
          ),
        ),
      ),
      body: tasksAsync.when(
        data: (allTasks) {
          //filter data for the calendar
          final Map<DateTime, bool> completionMap = {};

          for (var task in allTasks) {
            //check if dueDate exists
            if (task.dueDate != null) {
              DateTime dateKey = DateTime(
                task.dueDate!.year, 
                task.dueDate!.month, 
                task.dueDate!.day
              );
              
              //update the map
              completionMap[dateKey] = (completionMap[dateKey] ?? false) || !task.isCompleted;
            }
          }

          //filter for the Task Feed
          final incompleteTasks = allTasks.where((t) => !t.isCompleted).toList();

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Calendar",
                  style: AppStyle.title(context),
                ),
              ),

              CalendarView(
                targetMonth: selectedMonth,
                daysWithTask: completionMap,
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
                  ref.read(taskNotifierProvider.notifier)
                    .updateTaskCompletion(task.id, !task.isCompleted);
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