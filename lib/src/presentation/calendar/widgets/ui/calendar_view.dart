import 'package:flutter/material.dart';
import 'package:improov/src/data/models/task/task.dart';
import 'package:improov/src/core/constants/app_style.dart';

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
  bool _isExpanded = false;

  bool isSameDay(DateTime a, DateTime b) {
    return "${a.year}-${a.month}-${a.day}" == "${b.year}-${b.month}-${b.day}";
  }

  // --- REUSABLE DAY CELL ---
  Widget _buildDayCell(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final bool shouldBeBold = widget.daysWithTask[dateKey] ?? false;
    final bool isToday = isSameDay(date, DateTime.now());
    
    // Dim the text if the day belongs to the previous/next month in the week view
    final bool isOutsideTargetMonth = date.month != widget.targetMonth.month;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        final tasksForDay = await widget.getTasksForDate(date); 
        widget.onDayTap(date, tasksForDay);
      },
      child: Container(
        margin: isToday 
          ? const EdgeInsets.symmetric(horizontal: 6)
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
          "${date.day}", 
          style: TextStyle(
            fontSize: 16,
            color: isOutsideTargetMonth ? Colors.grey.shade400 : null,
            fontWeight: shouldBeBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // --- 1. WEEK VIEW ---
  Widget _buildWeekView() {
    // Check if the user changed the target month while in week view
    // If they did, snap the reference date to the 1st of the new target month
    DateTime referenceDate = widget.selectedDay;
    if (referenceDate.month != widget.targetMonth.month || referenceDate.year != widget.targetMonth.year) {
      referenceDate = DateTime(widget.targetMonth.year, widget.targetMonth.month, 1);
    }

    final int daysToSubtract = referenceDate.weekday - 1;
    final DateTime startOfWeek = referenceDate.subtract(Duration(days: daysToSubtract));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final DateTime date = startOfWeek.add(Duration(days: index));
          return Expanded(
            child: SizedBox(
              height: 40,
              child: _buildDayCell(date),
            ),
          );
        }),
      ),
    );
  }

  // --- 2. MONTH VIEW ---
  Widget _buildMonthView() {
    final firstDay = DateTime(widget.targetMonth.year, widget.targetMonth.month, 1);
    final lastDay = DateTime(widget.targetMonth.year, widget.targetMonth.month + 1, 0).day;
    final int leadingEmptyDays = firstDay.weekday - 1;
    final int totalSlots = leadingEmptyDays + lastDay;
    
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
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
        final date = DateTime(widget.targetMonth.year, widget.targetMonth.month, dayNumber);
        
        return _buildDayCell(date);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. CALENDAR HEADER & TOGGLE ---
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust horizontal padding to match your app
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Calendar",
                  style: AppStyle.title(context),
                ),
                Icon(
                  _isExpanded 
                    ? Icons.keyboard_arrow_up 
                    : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),

        // --- 2. ANIMATED BODY ---
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _isExpanded ? _buildMonthView() : _buildWeekView(),
        ),
      ],
    );
  }
}