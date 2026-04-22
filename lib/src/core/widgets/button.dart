import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSave;
  final bool isLoading;

  const Button({
    super.key,
    required this.text,
    required this.onTap,
    this.isSave = true,
    this.isLoading = false,
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
      onTap: isLoading 
        ? null 
        : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color:isLoading 
            ? buttonColor.withOpacity(0.6) 
            : buttonColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Text(
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