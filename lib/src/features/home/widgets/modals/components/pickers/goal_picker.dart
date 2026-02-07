import 'package:flutter/material.dart';

class GoalPicker extends StatelessWidget {
  final int selectedGoal;
  final Function(int) onChanged;

  const GoalPicker({
    super.key,
    required this.selectedGoal,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isDense: true,
          alignment: Alignment.centerRight,
          borderRadius: BorderRadius.circular(15),

          style: TextStyle(
            fontWeight: FontWeight.w600, // Bold as requested
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 14,
            letterSpacing: 0.5,
          ),

          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.grey,
          ),

          value: selectedGoal,
          underline: const SizedBox(),
          items: [1, 2, 3, 4, 5, 6, 7].map((int val) {
            return DropdownMenuItem(
              value: val,
              child: Text("$val days/week"),
            );
          }).toList(), 
          onChanged: (val) {
            if (val != null) onChanged(val);
          }
        ),
      ),
    );
  }
}