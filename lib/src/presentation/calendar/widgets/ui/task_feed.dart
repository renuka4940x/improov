import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
        child: Padding(
          padding: EdgeInsets.only(top: 140),
          child: Text("All caught up! No tasks here ;)"),
        )
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sortedDates.length,
      itemBuilder: (context, index) {
        final date = _sortedDates[index];
        final dateTasks = _groupedTasks[date]!;

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final bool isToday = date.isAtSameMomentAs(today);
        final bool isOverdue = date.isBefore(today);
        
        return Padding(
          padding: const EdgeInsets.only(right: 12, bottom: 10, left: 12),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Colors.grey.withValues(alpha: 0.5)),
                ExpansionTile(
                  key: PageStorageKey(date),
                  initiallyExpanded: isToday || isOverdue,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  
                  //H E A D E R
                  title: Text(
                    isToday ? "Today" : "${MonthName.getMonthName(date.month)}, ${date.day}",
                    style: AppStyle.title(context).copyWith(
                      color: isOverdue 
                        ? Colors.red.shade300 
                        : (isToday 
                          ? Theme.of(context).colorScheme.inversePrimary 
                          : null
                        ),
                    ),
                  ),
                  trailing: Text(
                    "${dateTasks.length}", 
                    style: GoogleFonts.jost(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isOverdue
                        ? Colors.red.shade300
                        : null
                    ),
                  ),

                  //T A S K  L I S T
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: dateTasks.map((t) => _buildTaskTile(context, t, ref)).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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