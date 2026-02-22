import 'package:flutter/material.dart';
import 'package:improov/src/features/streak/widgets/global_calendar/widgets/day_snapshot.dart';
import 'package:improov/src/features/streak/widgets/global_calendar/widgets/constellation_widget.dart';

class GlobalCalendarGrid extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final firstDay = DateTime(targetMonth.year, targetMonth.month, 1);
    final lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;
    final int leadingEmptyDays = firstDay.weekday - 1;

    return GridView.builder(
      shrinkWrap: true,
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
        final snapshot = snapshots[dayNumber] ?? DaySnapshot.empty();
        final date = DateTime(targetMonth.year, targetMonth.month, dayNumber);

        return GestureDetector(
          onTap: () => onDayTap(date, snapshot),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text("$dayNumber", style: const TextStyle(fontSize: 16)),
                ),
                const Spacer(),
                ConstellationWidget(count: snapshot.completedCount, hasOrigin: snapshot.hasOrigin),
                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }
}