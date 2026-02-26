import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:improov/src/core/widgets/month_name.dart';
import 'package:improov/src/data/models/habit.dart';

class HabitAuditSheet {
  static void show(
    BuildContext context, 
    DateTime date, 
    List<Habit> completedHabits
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _AuditContent(date: date, completedHabits: completedHabits),
    );
  }
}

class _AuditContent extends ConsumerWidget {
  final DateTime date;
  final List<Habit> completedHabits;

  const _AuditContent({required this.date, required this.completedHabits});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      //respects keyboard and notch
      padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          //date
          Text(
            "${MonthName.getMonthName(date.month)} ${date.day}, ${date.year}",
            style: AppStyle.title(context),
          ),

          const SizedBox(height: 24),

          //tasks completed that day
          if (completedHabits.isEmpty)
            _buildEmptyState()
          else
            ...completedHabits.map((h) => _buildHabitTile(context, h)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHabitTile(BuildContext context, Habit habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.tertiary, 
            size: 20
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              habit.name[0].toUpperCase() + habit.name.substring(1).toLowerCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary, 
                fontSize: 16, 
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.local_fire_department_outlined, 
                size: 16,
                color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.8),
              ),
              Text(
                "${habit.calculateStreak}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary, 
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            "No wins recorded for *this* day", 
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey[600]
            ),
          ),
        ],
      ),
    );
  }
}