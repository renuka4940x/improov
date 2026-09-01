import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/core/widgets/custom_checkbox.dart';
import 'package:improov/src/core/widgets/focused_menu_wrapper.dart';
import 'package:improov/src/presentation/home/widgets/modals/screen/modal.dart';
import 'package:improov/src/data/models/task/task.dart';
import 'package:improov/src/features/tasks/widget/task_popup.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TaskTile extends ConsumerStatefulWidget {
  final Task task;
  final bool isCompleted;
  final Function(bool?)? onChanged;

  const TaskTile({
    super.key,
    required this.task,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  ConsumerState<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends ConsumerState<TaskTile> {
  bool _isExpanded = false;

  void onEditPressed(BuildContext context) {
    showModalBottomSheet(
      context: Navigator.of(context, rootNavigator: true).context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => Modal(taskToEdit: widget.task, isUpdating: true),
    );
  }

  //delete function
  void onDeletePressed() {
    ref.read(taskProvider.notifier).deleteTask(widget.task.id);
  }

  @override
  Widget build(BuildContext context) {
    //check if subtasks exists
    final hasSubtasks = widget.task.subtasks.isNotEmpty;

    return FocusedMenuWrapper(
      onEdit: () => onEditPressed(context),
      onDelete: onDeletePressed, 
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
                  TaskPopup(task: widget.task),
                ],
              );
            },
          ),
        );
      },
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- MAIN TASK ROW ---
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            //tap for check/uncheck
            onTap: () {
              ref
                  .read(taskProvider.notifier)
                  .updateTaskCompletion(widget.task.id, !widget.task.isCompleted);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Material(
                type: MaterialType.transparency,
                child: Row(
                  children: [
                    //checkbox
                    Transform.scale(
                      scale: 1.2,
                      child: CustomCheckbox(
                        value: widget.isCompleted,
                        onChanged: widget.onChanged, 
                      ),
                    ),

                    const SizedBox(width: 12),

                    //task name
                    Expanded(
                      child: Text(
                        widget.task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: widget.isCompleted ? Colors.grey : null,
                          decoration: widget.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                          decorationColor: widget.isCompleted
                            ? Colors.grey
                            : Colors.transparent,
                          fontStyle: widget.isCompleted ? FontStyle.italic : null,
                        ),
                      ),
                    ),
                    
                    //accordion icon based on subtask's existence
                    if (hasSubtasks)
                      // IconButton
                      IconButton(
                        onPressed: () {
                          setState(() => _isExpanded = !_isExpanded);
                        },
                        icon: Icon(
                          _isExpanded
                            ? PhosphorIconsRegular.caretUp
                            : PhosphorIconsRegular.caretDown,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        splashRadius: 20,
                      ),
                    
                  ],
                ),
              ),
            ),
          ),
          
          //THE SUBTASKS BLOCK
          if (hasSubtasks)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: double.infinity,
                height: _isExpanded ? null : 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 34, 
                    top: 2, 
                    bottom: 2, 
                    right: 10,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                    ),
                    // Space between the vertical line and the subtasks
                    padding: const EdgeInsets.only(left: 16.0), 
                    child: Column(
                      children: widget.task.subtasks.map((subtask) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),

                          child: FocusedMenuWrapper(
                            onEdit: () {
                              // Editing from the menu opens the modal focused on this subtask
                              showModalBottomSheet(
                                context: Navigator.of(context, rootNavigator: true).context,
                                useSafeArea: true,
                                isScrollControlled: true,
                                builder: (context) => Modal(
                                  taskToEdit: widget.task,
                                  isUpdating: true,
                                  autoFocusSubtaskUuid: subtask.uuid,
                                ),
                              );
                            },
                            onDelete: () {
                              //Deletes specifically THIS subtask!
                              ref.read(taskProvider.notifier).deleteSubtask(
                                widget.task.id,
                                subtask.uuid,
                              );
                            },
                            onDetails: () {
                               // You can leave this empty or make it do the same as Edit
                            },

                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                //tapping anywhere on the row checks/unchecks it
                                ref.read(taskProvider.notifier).toggleSubtaskCompletion(
                                  widget.task.id,
                                  subtask.uuid,
                                  !subtask.isCompleted,
                                );
                              },

                              child: Row(
                                children: [
                                  // Subtask Checkbox
                                  CustomCheckbox(
                                    value: subtask.isCompleted,
                                    onChanged: (val) {
                                      ref.read(taskProvider.notifier).toggleSubtaskCompletion(
                                        widget.task.id,
                                        subtask.uuid,
                                        val ?? false,
                                      );
                                    },
                                  ),
                                  
                                  const SizedBox(width: 12),
                                  
                                  // Subtask Title
                                  Expanded(
                                    child: Text(
                                      subtask.title ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: subtask.isCompleted ? Colors.grey : null,
                                        decoration: subtask.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                        fontStyle: subtask.isCompleted
                                          ? FontStyle.italic
                                          : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}