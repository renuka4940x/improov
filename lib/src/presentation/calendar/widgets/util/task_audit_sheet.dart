import 'package:flutter/material.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:improov/src/core/widgets/month_name.dart';
import 'package:improov/src/data/models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';

class TaskAuditSheet {
  static Future<void> show(BuildContext context, DateTime date, List<Task> tasks) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _TaskAuditContent(date: date, tasks: tasks),
    );
  }
}

class _TaskAuditContent extends ConsumerStatefulWidget {
  final DateTime date;
  final List<Task> tasks;

  const _TaskAuditContent({
    required this.date, 
    required this.tasks
  });

  @override
  ConsumerState<_TaskAuditContent> createState() => _TaskAuditContentState();
}

class _TaskAuditContentState extends ConsumerState<_TaskAuditContent> {
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = widget.tasks;
  }

  void _toggleTask(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });

    // 2. Sync with DB
    ref.read(taskNotifierProvider.notifier).updateTaskCompletion(task.id, task.isCompleted);
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          //date
          Text(
            "${MonthName.getMonthName(widget.date.month)} ${widget.date.day}, ${widget.date.year}", 
            style: AppStyle.title(context)
          ),
          const SizedBox(height: 24),
          
          if (_tasks.isEmpty)
            _buildEmptyState()
          else
            ..._tasks.map((t) => _buildTaskTile(context, t)),
        ],
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, Task task) {
    return GestureDetector(
      onTap: () => _toggleTask(task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: task.isCompleted 
            ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2) 
            : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.isCompleted 
                ? Theme.of(context).colorScheme.tertiary
                : Colors.grey
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                task.title, style: const TextStyle(fontSize: 16)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            "it's a rest day, enjoy~", 
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey[600]
            ),
          ),
        ],
      ),
    );
  }
}