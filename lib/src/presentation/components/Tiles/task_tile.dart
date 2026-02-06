import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:improov/src/data/database/task_database.dart';
import 'package:improov/src/data/models/task.dart';
import 'package:improov/src/presentation/util/modals/modal.dart';
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
      context: context,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(), 
          children: [
            SlidableAction(
              //edit
              onPressed: (context) => onEditPressed(context),
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(8),
            ),
      
            //delete
            SlidableAction(
              onPressed: (context) => onDeletePressed(context),
              backgroundColor: Colors.red.shade300,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        
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
                  color: isCompleted ? Colors.grey : null,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  fontStyle: isCompleted ? FontStyle.italic : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}