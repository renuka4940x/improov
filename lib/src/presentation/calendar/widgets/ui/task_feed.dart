import 'package:flutter/material.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:improov/src/core/widgets/month_name.dart';
import 'package:improov/src/data/models/task.dart';

class TaskFeed extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onToggle;

  const TaskFeed({
    super.key,
    required this.tasks,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, List<Task>> groupedTasks = {};
    for (var task in tasks) {
      final date = DateTime((task.dueDate ?? DateTime.now()).year, (task.dueDate ?? DateTime.now()).month, (task.dueDate ?? DateTime.now()).day);
      groupedTasks.putIfAbsent(date, () => []).add(task);
    }

    final sortedDates = groupedTasks.keys.toList()..sort();

    if (sortedDates.isEmpty) {
      return const Center(
        child: Text("All caught up! No tasks here.")
      );
    }

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dateTasks = groupedTasks[date]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              "${MonthName.getMonthName(date.month)}, ${date.day}",
              style: AppStyle.title(context),
            ),
            const SizedBox(height: 6),

            ...dateTasks.map((t) => _buildTaskTile(context, t)),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildTaskTile(BuildContext context, Task task) {
    return ListTile(
      leading: Icon(
        task.isCompleted 
          ? Icons.check_box
          : Icons.check_box_outline_blank_rounded
      ),
      title: Text(task.title),
      onTap: () => onToggle(task),
    );
  }
}