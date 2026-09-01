import 'package:flutter/material.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:improov/src/presentation/streak/widgets/global_calendar/widgets/day_snapshot_habit.dart';
import 'package:improov/src/presentation/streak/widgets/global_calendar/widgets/constellation_widget.dart';

class GlobalCalendarGrid extends StatefulWidget {
  final DateTime targetMonth;
  final Map<int, DaySnapshot> snapshots;
  final Function(DateTime, DaySnapshot) onDayTap;

  const GlobalCalendarGrid({
    super.key, 
    required this.targetMonth, 
    required this.snapshots,
    required this.onDayTap,
  });

  @override
  State<GlobalCalendarGrid> createState() => _GlobalCalendarGridState();
}

class _GlobalCalendarGridState extends State<GlobalCalendarGrid> {
  bool _isExpanded = false;

  // --- REUSABLE DAY CELL ---
  Widget _buildDayCell(DateTime date) {
    // If the day belongs to the previous/next month in week view, dim it and hide constellations
    final bool isOutsideTargetMonth = date.month != widget.targetMonth.month;
    final int dayNumber = date.day;
    
    // Only grab snapshot data if it's actually in the target month
    final snapshot = isOutsideTargetMonth 
        ? DaySnapshot.empty() 
        : (widget.snapshots[dayNumber] ?? DaySnapshot.empty());

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.onDayTap(date, snapshot),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                "$dayNumber", 
                style: TextStyle(
                  fontSize: 16,
                  color: isOutsideTargetMonth ? Colors.grey.shade400 : null,
                ),
              ),
            ),
            const Spacer(),
            
            // Constellation Widget (Faded out completely if outside the month)
            Opacity(
              opacity: isOutsideTargetMonth ? 0.0 : 1.0,
              child: ConstellationWidget(
                count: snapshot.completedCount, 
                hasOrigin: snapshot.hasOrigin,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  // --- 1. WEEK VIEW ---
  Widget _buildWeekView() {
    DateTime referenceDate;
    final now = DateTime.now();
    
    // Smart Snap: If looking at the current month, lock to this week. 
    // Otherwise, lock to the 1st of the target month.
    if (widget.targetMonth.year == now.year && widget.targetMonth.month == now.month) {
      referenceDate = now;
    } else {
      referenceDate = DateTime(widget.targetMonth.year, widget.targetMonth.month, 1);
    }

    final int daysToSubtract = referenceDate.weekday - 1;
    final DateTime startOfWeek = referenceDate.subtract(Duration(days: daysToSubtract));

    return Row(
      children: List.generate(7, (index) {
        final DateTime date = startOfWeek.add(Duration(days: index));
        
        return Expanded(
          child: Container(
            // Matches the GridView crossAxisSpacing of 8
            margin: EdgeInsets.only(right: index < 6 ? 8.0 : 0), 
            child: AspectRatio(
              aspectRatio: 1.0, // Forces perfect squares just like the GridView!
              child: _buildDayCell(date),
            ),
          ),
        );
      }),
    );
  }

  // --- 2. MONTH VIEW ---
  Widget _buildMonthView() {
    final firstDay = DateTime(widget.targetMonth.year, widget.targetMonth.month, 1);
    final lastDay = DateTime(widget.targetMonth.year, widget.targetMonth.month + 1, 0).day;
    final int leadingEmptyDays = firstDay.weekday - 1;

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leadingEmptyDays + lastDay,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        if (index < leadingEmptyDays) return const SizedBox.shrink();

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
        // --- HEADER & TOGGLE ---
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Streaks",
                  style: AppStyle.title(context),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),

        // --- ANIMATED GRID/WEEK ---
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