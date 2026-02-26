import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?)? onChanged;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value, 
      onChanged: onChanged,
      side: BorderSide(
        color: value
          ? Colors.transparent
          : Theme.of(context).colorScheme.inversePrimary,
        width: 1.5,
      ),
      activeColor: Theme.of(context).colorScheme.tertiary,
      checkColor: Theme.of(context).colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),

      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Theme.of(context).colorScheme.tertiary;
        }
        return Colors.transparent;
      }),
    );
  }
}