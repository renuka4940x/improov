import 'package:flutter/material.dart';
import 'package:improov/src/features/tasks/provider/task_provider.dart';
import 'package:improov/src/presentation/calendar/widgets/ui/calendar_view.dart';
import 'package:improov/src/presentation/calendar/widgets/util/day_audit_sheet_task.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  // ignore: unused_field
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
    _loadTaskDates();
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
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
                  onDayTap: ( date, tasks) async {
                    setState(() => _selectedDay = date);
                    if (!mounted) return;
                    
                    //open the Audit Sheet
                    await TaskAuditSheet.show(context, date, tasks);
                    _loadTaskDates();
                  },
                );
              },
            ),
            const SizedBox(height: 20,),
            const Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}