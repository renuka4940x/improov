import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSave;

  const Button({
    super.key,
    required this.text,
    required this.onTap,
    this.isSave = true,
  });

  @override
  Widget build(BuildContext context) {

    final Color buttonColor = isSave 
      ? Theme.of(context).colorScheme.inversePrimary
      : Colors.red.shade300;

    final Color textColor = isSave
      ? Theme.of(context).colorScheme.primary
      : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}