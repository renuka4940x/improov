import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improov/src/core/util/modals/widgets/toggle/toggle_label.dart';

class BuildToggle extends StatelessWidget {
  final bool isHabitMode;
  final ValueChanged<bool> onToggle;

  const BuildToggle({
    super.key,
    required this.isHabitMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<bool>(
      groupValue: isHabitMode,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      thumbColor: Theme.of(context).colorScheme.inversePrimary,
      children: {
        false: ToggleLabel(
          text: 'TASK', 
          isSelected: !isHabitMode,
        ),
        true: ToggleLabel(
          text: "HABIT", 
          isSelected: isHabitMode,
        ),
      }, 
      onValueChanged: (val) =>  onToggle(val!),
    );
  }
}