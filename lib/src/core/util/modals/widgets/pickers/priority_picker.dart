import 'package:flutter/material.dart';
import 'package:improov/src/data/models/enums/priority.dart';

class PriorityPicker extends StatelessWidget {
  final Priority selectedPriority;
  final Function(Priority) onChanged;

  const PriorityPicker({
    super.key,
    required this.selectedPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Priority>(
          value: selectedPriority,
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

          items: Priority.values.map((Priority p) {
            return DropdownMenuItem(
              value: p,
              child: Text(
                p.name[0].toUpperCase() + p.name.substring(1),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }
}