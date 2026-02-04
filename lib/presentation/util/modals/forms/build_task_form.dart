import 'package:flutter/material.dart';
import 'package:improov/presentation/util/modals/widgets/build_row.dart';

class BuildTaskForm extends StatelessWidget {
  const BuildTaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //date
        BuildRow(
          label: "Date",  
          trailing: Text("Today, 15 Oct"),
        ),

        //priority
        BuildRow(
          label: "Priority",
          trailing: Text("Low"),
        ),

        //reminders
        BuildRow(
          label: "Reminder", 
          trailing: Text("Off"), 
          isPro: true
        ),
      ],
    );
  }
}