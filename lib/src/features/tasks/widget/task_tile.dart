import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/core/widgets/custom_checkbox.dart';
import 'package:improov/src/core/widgets/focused_menu_wrapper.dart';
import 'package:improov/src/presentation/home/widgets/modals/screen/modal.dart';
import 'package:improov/src/data/models/task.dart';
import 'package:improov/src/features/tasks/widget/task_popup.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';

class TaskTile extends ConsumerWidget {
  final Task task;
  final bool isCompleted;
  final Function(bool?)? onChanged;

  const TaskTile({
    super.key,
    required this.task,
    required this.isCompleted,
    required this.onChanged,
  });

  void onEditPressed(BuildContext context) {
    showModalBottomSheet(
      context: Navigator.of(context, rootNavigator: true).context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => Modal(
        taskToEdit: task,
        isUpdating: true,
      )
    );
  }

  //delete function
  void onDeletePressed(WidgetRef ref) {
    ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FocusedMenuWrapper(
      onEdit: () => onEditPressed(context),
      onDelete: () => onDeletePressed(ref),
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
                          
        //tap for check/uncheck
        onTap: () {
          ref.read(taskNotifierProvider.notifier).updateTaskCompletion(task.id, !task.isCompleted);
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
                    value: isCompleted, 
                    onChanged: onChanged,
                  ),
                ),
            
                const SizedBox(width: 12),
            
                //task name
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isCompleted 
                        ? Colors.grey 
                        : null,
                      decoration: isCompleted 
                        ? TextDecoration.lineThrough 
                        : null,
                      decorationColor: isCompleted
                        ? Colors.grey
                        : Colors.transparent,
                      fontStyle: isCompleted 
                        ? FontStyle.italic 
                        : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}