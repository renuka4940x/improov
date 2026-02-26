import 'package:flutter/material.dart';
import 'package:improov/src/data/models/task.dart';
import 'package:improov/src/features/tasks/provider/task_database.dart';
import 'package:improov/src/features/tasks/provider/task_provider.dart';
import 'package:improov/src/presentation/calendar/widgets/ui/calendar_view.dart';
import 'package:improov/src/presentation/calendar/widgets/ui/task_feed.dart';
import 'package:improov/src/presentation/calendar/widgets/util/day_audit_sheet_task.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late TaskProvider _taskProvider;
  late TaskDatabase _taskDatabase;

  DateTime _selectedMonth = DateTime(
    DateTime.now().year, DateTime.now().month, 1
  );

  DateTime _selectedDay = DateTime.now();

  void _changeMonth(int increment) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + increment, 1);
    });
  }

  List<DateTime> _taskDates = [];

  // Fetch these when the page loads or when the month changes
  Future<void> _loadTaskDates() async {
    final tasks = await context.read<TaskProvider>().getTaskDatesForMonth(_selectedMonth);
    setState(() {
      _taskDates = tasks.map((d) => stripTime(d)).toSet().toList();
    });
  }

  DateTime stripTime(DateTime d) => DateTime(d.year, d.month, d.day);


  @override
  void initState() {
    super.initState();

    _taskProvider = context.read<TaskProvider>();
    _taskDatabase = context.read<TaskDatabase>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100)); 
      
      if (!mounted) return;
      await _loadTaskDates();
      
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      _taskProvider.getAllIncompleteTasks(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListenableBuilder(
            listenable: context.read<TaskProvider>(),
            builder: (context, _) {
              return CalendarView(
                key: ValueKey(_taskDates.length),
                targetMonth: _selectedMonth,
                daysWithTask: _taskDates,
                selectedDay: _selectedDay,
                getTasksForDate: (date) => context.read<TaskProvider>().getTasksForDate(date),
                onDayTap: (date, tasks) async {
                  setState(() => _selectedDay = date);
                  if (!mounted) return;
                  await TaskAuditSheet.show(context, date, tasks);
                  _loadTaskDates();
                },
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          StreamBuilder<List<Task>>(
            stream: _taskProvider.watchIncompleteTasks(),
            builder: (context, snapshot) {
              // 1. Handle loading or empty states
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              // 2. Access the fresh, reactive data
              final tasks = snapshot.data ?? [];

              return TaskFeed(
                tasks: tasks,
                onToggle: (task) async {

                  await _taskDatabase.updateTaskCompletion(
                    task.id, 
                    !task.isCompleted,
                  );

                  if (!mounted) return;

                  _taskProvider.getAllIncompleteTasks(forceRefresh: true);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}