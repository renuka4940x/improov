import 'package:flutter/material.dart';
import 'package:improov/src/presentation/util/modals/widgets/input/build_row.dart';

class BuildHabitForm extends StatelessWidget {
  const BuildHabitForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //times of the week
        BuildRow(
          label: "Goal",
          trailing: Text("3 times"),
        ),

        //priority
        BuildRow(
          label: "Priority",
          trailing: Text("Low"),
        ),

        //reminders
        BuildRow(
          label: "Reminder", 
          trailing: Text("Off"), isPro: true
        ),
      ]
    );
  }
}