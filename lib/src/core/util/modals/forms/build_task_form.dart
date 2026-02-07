import 'package:flutter/material.dart';
import 'package:improov/src/core/util/modals/widgets/UI/build_row.dart';
import 'package:improov/src/core/util/modals/widgets/pickers/date_picker.dart';
import 'package:improov/src/core/util/modals/widgets/pickers/date_time_picker.dart';
import 'package:improov/src/core/util/modals/widgets/pickers/priority_picker.dart';
import 'package:improov/src/data/enums/priority.dart';

class BuildTaskForm extends StatelessWidget {
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
          trailing: DateTimePicker(
            selectedDateTime: currentReminder,
            label: "Off", 
            onDateTimeSelected: onDateTimeSelected,
          ), 
          isPro: true
        ),
      ],
    );
  }
}