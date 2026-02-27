import 'package:flutter/material.dart';
import 'package:improov/src/data/models/task.dart';

class CalendarView extends StatefulWidget {
  final DateTime targetMonth;
  final DateTime selectedDay;
  final Future<List<Task>> Function(DateTime) getTasksForDate;
  final Function(DateTime, List<Task>) onDayTap;
  final Map<DateTime, bool> daysWithTask;

  const CalendarView({
    super.key, 
    required this.targetMonth,
    required this.selectedDay, 
    required this.getTasksForDate,
    required this.onDayTap,
    this.daysWithTask = const {},
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

        

        final dateKey = DateTime(date.year, date.month, date.day);

        final bool shouldBeBold = widget.daysWithTask[dateKey] ?? false;

        final bool isToday = isSameDay(date, DateTime.now());
        
        return GestureDetector(
          onTap: () async {
            final tasksForDay = await widget.getTasksForDate(date); 
            widget.onDayTap(date, tasksForDay);
          },
          child: Container(
            margin: isToday 
              ? EdgeInsets.symmetric(horizontal: 6)
              : EdgeInsets.zero,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: isToday 
              ? Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary, 
                    width: 2,
                  ),
                ) 
              : null,
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