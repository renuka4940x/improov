import 'package:flutter/material.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:improov/src/core/widgets/custom_checkbox.dart';
import 'package:improov/src/core/widgets/month_name.dart';
import 'package:improov/src/data/models/task.dart';

class TaskFeed extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onToggle;

  const TaskFeed({
    super.key,
    required this.tasks,
    required this.onToggle,
  });

  @override
  State<TaskFeed> createState() => _TaskFeedState();
}

class _TaskFeedState extends State<TaskFeed> {
  Map<DateTime, List<Task>> _groupedTasks = {};
  List<DateTime> _sortedDates = [];

  @override
  void initState() {
    super.initState();
    _processTasks();
  }

  @override
  void didUpdateWidget(TaskFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tasks != oldWidget.tasks) {
      _processTasks();
    }
  }

  void _processTasks() {
    _groupedTasks = {};
    for (var task in widget.tasks) {
      final date = DateTime(
        (task.dueDate ?? DateTime.now()).year, 
        (task.dueDate ?? DateTime.now()).month, 
        (task.dueDate ?? DateTime.now()).day
      );

      _groupedTasks.putIfAbsent(date, () => []).add(task);
    }
    _sortedDates = _groupedTasks.keys.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {

    if (_sortedDates.isEmpty) {
      return const Center(
        child: Text("All caught up! No tasks here.")
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sortedDates.length,
      itemBuilder: (context, index) {
        final date = _sortedDates[index];
        final dateTasks = _groupedTasks[date]!;
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                "${MonthName.getMonthName(date.month)}, ${date.day}",
                style: AppStyle.title(context),
              ),
              const SizedBox(height: 6),
          
              ...dateTasks.map((t) => _buildTaskTile(context, t)),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskTile(BuildContext context, Task task) {
    final bool isCompleted = task.isCompleted;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.onToggle(task),
      child: Row(
        children: [
          CustomCheckbox(
            value: isCompleted,
            onChanged: (bool? newValue) => widget.onToggle(task),
          ),
          Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}