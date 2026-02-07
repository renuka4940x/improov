import 'package:flutter/material.dart';
import 'package:improov/src/core/util/formatters/date_formatter.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/core/widgets/popup_row.dart';

class HabitPopup extends StatelessWidget {
  final Habit habit;

  const HabitPopup({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'habit_${habit.id}',
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
                        habit.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      if (habit.description != null && habit.description!.isNotEmpty)
                        Text(habit.description!, style: TextStyle(color: Colors.grey[600])),
                      const Divider(height: 32),
                      
                      // Priority
                      PopupRow(
                        icon: Icons.priority_high_outlined, 
                        label: "Priority", 
                        value: habit.priority.name[0].toUpperCase() + habit.priority.name.substring(1).toLowerCase(),
                      ),
            
                      //goal
                      PopupRow(
                        icon: Icons.local_fire_department_outlined, 
                        label: "Goal", 
                        value: "${habit.goalDaysPerWeek} days/week",
                      ),
            
                      //reminder
                      PopupRow(
                        icon: Icons.alarm_outlined, 
                        label: "Reminder", 
                        value: habit.reminderTime != null 
                          ? DateFormatter.formatDateTime(habit.reminderTime!) 
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