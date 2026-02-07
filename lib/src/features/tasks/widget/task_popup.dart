import 'package:flutter/material.dart';
import 'package:improov/src/core/util/formatters/date_formatter.dart';
import 'package:improov/src/data/models/task.dart';
import 'package:improov/src/presentation/components/UI/popup_row.dart';

class TaskPopup extends StatelessWidget {
  final Task task;

  const TaskPopup({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'task_${task.id}',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      if (task.description != null && task.description!.isNotEmpty)
                        Text(task.description!, style: TextStyle(color: Colors.grey[600])),
                      const Divider(height: 32),
                      
                      //priority
                      PopupRow(
                        icon: Icons.priority_high_outlined, 
                        label: "Priority", 
                        value: task.priority.name[0].toUpperCase() + task.priority.name.substring(1).toLowerCase(),
                      ),
                      
                      //due date
                      PopupRow(
                        icon: Icons.calendar_today_outlined, 
                        label: "Due on", 
                        value: "${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}",
                      ),
            
                      //reminder
                      PopupRow(
                        icon: Icons.alarm_outlined, 
                        label: "Reminder", 
                        value: task.reminderTime != null 
                          ? DateFormatter.formatDateTime(task.reminderTime!) 
                          : "Off",
                      ),
            
                      const SizedBox(height: 16),
                      //done
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Done", 
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}