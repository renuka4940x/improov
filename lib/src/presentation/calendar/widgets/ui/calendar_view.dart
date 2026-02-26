import 'package:flutter/material.dart';
import 'package:improov/src/data/models/task.dart';

class CalendarView extends StatefulWidget {
  final DateTime targetMonth;
  final DateTime selectedDay;
  final Future<List<Task>> Function(DateTime) getTasksForDate;
  final Function(DateTime, List<Task>) onDayTap;
  final List<DateTime> daysWithTask;

  const CalendarView({
    super.key, 
    required this.targetMonth,
    required this.selectedDay, 
    required this.getTasksForDate,
    required this.onDayTap,
    this.daysWithTask = const [],
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {

  DateTime stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

  bool isSameDay(DateTime a, DateTime b) {
    return "${a.year}-${a.month}-${a.day}" == "${b.year}-${b.month}-${b.day}";
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(widget.targetMonth.year, widget.targetMonth.month, 1);

    //get the last day of the month by going to next month, day 0
    final lastDay = DateTime(widget.targetMonth.year, widget.targetMonth.month + 1, 0).day;
    final int leadingEmptyDays = firstDay.weekday - 1;
    final int totalSlots = leadingEmptyDays + lastDay;

    final taskSet = widget.daysWithTask
      .map((d) => "${d.year}-${d.month}-${d.day}")
      .toSet();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalSlots,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),

      itemBuilder: (context, index) {

        if (index < leadingEmptyDays) {
          return const SizedBox.shrink();
        }

        final dayNumber = index - leadingEmptyDays + 1;
        final rawDate = DateTime(widget.targetMonth.year, widget.targetMonth.month, dayNumber);
        final date = DateTime(rawDate.year, rawDate.month, rawDate.day);

        //check if a date has task
        final dateKey = "${date.year}-${date.month}-${date.day}";
        final bool hasTask = taskSet.contains(dateKey);

        final bool shouldBeBold = hasTask;

        final bool isToday = isSameDay(date, DateTime.now());
        
        return GestureDetector(
          onTap: () async {
            final tasksForDay = await widget.getTasksForDate(date); 
            widget.onDayTap(date, tasksForDay);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isToday 
                ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2) 
                : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "$dayNumber", 
              style: TextStyle(
                fontSize: 16,
                fontWeight: shouldBeBold
                  ? FontWeight.bold
                  : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}