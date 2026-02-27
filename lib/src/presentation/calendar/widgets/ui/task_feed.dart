import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:improov/src/core/widgets/custom_checkbox.dart';
import 'package:improov/src/core/widgets/focused_menu_wrapper.dart';
import 'package:improov/src/core/widgets/month_name.dart';
import 'package:improov/src/data/models/task.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';
import 'package:improov/src/features/tasks/widget/task_popup.dart';
import 'package:improov/src/presentation/home/widgets/modals/screen/modal.dart';

class TaskFeed extends ConsumerStatefulWidget {
  final List<Task> tasks;
  final Function(Task) onToggle;

  const TaskFeed({
    super.key,
    required this.tasks,
    required this.onToggle,
  });

  @override
  ConsumerState<TaskFeed> createState() => _TaskFeedState();
}

class _TaskFeedState extends ConsumerState<TaskFeed> {
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

  //Edit
  void _onDeleteTask(WidgetRef ref, int id) {
    ref.read(taskNotifierProvider.notifier).deleteTask(id);
  }

  // EDIT
  void _onEditTask(BuildContext context, Task task) {
    // Reusing your modal logic
    showModalBottomSheet(
      context: Navigator.of(context, rootNavigator: true).context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => Modal(
        taskToEdit: task,
        isUpdating: true,
      ),
    );
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
          
              ...dateTasks.map((t) => _buildTaskTile(context, t, ref)),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskTile(BuildContext context, Task task, WidgetRef ref) {
    final bool isCompleted = task.isCompleted;

    return FocusedMenuWrapper(
      onEdit: () => _onEditTask(context, task),
      onDelete: () => _onDeleteTask(ref, task.id), 
      onDetails: () {
        HapticFeedback.mediumImpact();
        Navigator.of(context, rootNavigator: true).push(
          PageRouteBuilder(
            opaque: false,
            barrierDismissible: true,
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return Stack(
                children: [
                  
                  //B L U R
                  FadeTransition(
                    opacity: animation,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),

                  //P O P U P
                  TaskPopup(task: task),
                ],
              );
            },
          ),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => widget.onToggle(task),
        child: Row(
          children: [
            CustomCheckbox(
              value: isCompleted,
              onChanged: (bool? newValue) => widget.onToggle(task),
            ),
            Expanded(
              child: Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}