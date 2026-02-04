import 'package:flutter/material.dart';

class ToggleLabel extends StatelessWidget {
  final String text;
  final bool isSelected;

  const ToggleLabel({
    super.key,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isSelected 
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}