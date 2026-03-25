import 'package:flutter/material.dart';
import 'package:improov/src/core/widgets/build_row.dart';
import 'package:improov/src/presentation/home/widgets/modals/components/pickers/date_picker.dart';
import 'package:improov/src/presentation/home/widgets/modals/components/pickers/date_time_picker.dart';
import 'package:improov/src/presentation/home/widgets/modals/components/pickers/priority_picker.dart';
import 'package:improov/src/data/enums/priority.dart';

class BuildTaskForm extends StatelessWidget {
  //revenueCat parameters
  final bool isPremium;
  final VoidCallback onPremiumLockedTap;

  //variables
  final DateTime currentStartDate;
  final Priority currentPriority;
  final DateTime? currentReminder;

  //callbacks
  final Function(DateTime) onDateChanged;
  final Function(Priority) onPriorityChanged;
  final Function(DateTime?) onDateTimeSelected;

  const BuildTaskForm({
    super.key,
    required this.isPremium,
    required this.onPremiumLockedTap,
    required this.currentStartDate,
    required this.currentPriority,
    required this.currentReminder,
    required this.onDateChanged,
    required this.onPriorityChanged,
    required this.onDateTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //date
        BuildRow(
          label: "Date",  
          trailing:DatePicker(
            selectedDate: currentStartDate,
            onDateSelected: onDateChanged,
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
      ],
    );
  }
}