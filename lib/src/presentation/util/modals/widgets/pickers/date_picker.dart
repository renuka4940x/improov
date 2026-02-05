import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, 
      firstDate: DateTime.now().subtract(const Duration(days: 365)), 
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              //header &selected day bg
              primary: Theme.of(context).colorScheme.tertiary,
              //text on top of selection
              onPrimary: Theme.of(context).colorScheme.onTertiary,
              //dialog bg
              surface: Theme.of(context).colorScheme.primary,
              onSurface: Theme.of(context).colorScheme.inversePrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        child: Text(
          DateFormat('MMM d, yyyy').format(selectedDate),

          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 14,
            letterSpacing: 0.5,
          )
        ),
      ),
    );
  }
}