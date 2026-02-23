import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:improov/src/core/widgets/focused_menu_wrapper.dart';
import 'package:improov/src/features/home/widgets/modals/screen/modal.dart';
import 'package:improov/src/features/tasks/provider/task_database.dart';
import 'package:improov/src/data/models/task.dart';
import 'package:improov/src/features/tasks/widget/task_popup.dart';
import 'package:improov/src/core/routing/hero_dialog_route.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
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
  void onDeletePressed(BuildContext context) {
    context.read<TaskDatabase>().deleteTask(task.id);
  }

  @override
  Widget build(BuildContext context) {
    return FocusedMenuWrapper(
      onEdit: () => onEditPressed(context),
      onDelete: () => onDeletePressed(context),
      onDetails: () {
        HapticFeedback.mediumImpact();
        Navigator.push(
          context,
          HeroDialogRoute(builder: (context) => TaskPopup(task: task)),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
                          
        //tap for check/uncheck
        onTap: () {
          context.read<TaskDatabase>().updateTaskCompletion(
            task.id, 
            !task.isCompleted,
          );
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
                  child: Checkbox(
                    side: BorderSide(
                      color: isCompleted
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.inversePrimary,
                      width: 1.5,
                    ),
                    value: isCompleted, 
                    onChanged: onChanged,
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    checkColor: Theme.of(context).colorScheme.inversePrimary,
            
                    fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).colorScheme.tertiary;
                    }
                      return Colors.transparent;
                    }),
                    
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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