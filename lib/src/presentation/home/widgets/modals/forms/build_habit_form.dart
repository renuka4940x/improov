import 'package:flutter/material.dart';
import 'package:improov/src/core/widgets/build_row.dart';
import 'package:improov/src/presentation/home/widgets/modals/components/pickers/date_time_picker.dart';
import 'package:improov/src/presentation/home/widgets/modals/components/pickers/goal_picker.dart';
import 'package:improov/src/presentation/home/widgets/modals/components/pickers/priority_picker.dart';
import 'package:improov/src/data/enums/priority.dart';

class BuildHabitForm extends StatelessWidget {
  //revenueCat parameters
  final bool isPremium;
  final VoidCallback onPremiumLockedTap;
  //variables
  final Priority currentPriority;
  final int currentGoal;
  final DateTime? currentReminder;

  //function callbacks
  final Function(Priority) onPriorityChanged;
  final Function(int) onGoalChanged;
  final Function(DateTime?) onDateTimeSelected;

  const BuildHabitForm({
    super.key,
    required this.isPremium,
    required this.onPremiumLockedTap,
    required this.currentPriority,
    required this.currentGoal,
    required this.currentReminder,
    required this.onPriorityChanged,
    required this.onGoalChanged,
    required this.onDateTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //times of the week
        BuildRow(
          label: "Goal",
          trailing: GoalPicker(
            selectedGoal: currentGoal, 
            onChanged: onGoalChanged
          ),
        ),

        //priority
        BuildRow(
          label: "Priority",
          trailing: PriorityPicker(
            selectedPriority: currentPriority, 
            onChanged: onPriorityChanged,
          ),
        ),

        //reminders
        BuildRow(
          label: "Reminder",
          isPro: !isPremium,
          trailing: GestureDetector(
            onTap: isPremium 
              ? null 
              : onPremiumLockedTap,
            child: AbsorbPointer(
              absorbing: !isPremium,
              child: Opacity(
                opacity: isPremium 
                  ? 1.0 
                  : 0.5,
                child: DateTimePicker(
                  selectedDateTime: currentReminder,
                  label: "Off", 
                  onDateTimeSelected: onDateTimeSelected,
                ),
              ),
            ),
          ),
        ),
      ]
    );
  }
}