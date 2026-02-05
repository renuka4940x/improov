import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime? selectedDateTime;
  final String label;
  final Function(DateTime) onDateTimeSelected;

  const DateTimePicker({
    super.key,
    required this.selectedDateTime,
    required this.label,
    required this.onDateTimeSelected,
  });

  Future<void> _pickDateTime(BuildContext context) async {
    //pick the day
    final DateTime? date = await showDatePicker(
      context: context, 
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2030),
    );

    if (date == null ) return;

    //pick time after date picker is closed
    if (!context.mounted) return;

    final TimeOfDay? time = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
    );

    if (time == null) return;

    //combine above two to make a datetime object
    final DateTime combined = DateTime(
      date.year, date.month, date.day,
      time.hour, time.minute,
    );

    onDateTimeSelected(combined);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDateTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),

        child: Text(
          selectedDateTime == null 
              ? "Set $label" 
              : DateFormat('MMM d, h:mm a').format(selectedDateTime!),

          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
    );
  }
}