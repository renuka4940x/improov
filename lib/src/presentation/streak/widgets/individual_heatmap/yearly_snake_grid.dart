import 'package:flutter/material.dart';
import 'package:improov/src/data/models/habit/habit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart';
import 'package:improov/src/presentation/streak/widgets/individual_heatmap/habit_calendar.dart';
import 'package:shimmer/shimmer.dart';

class YearlySnakeGrid extends ConsumerStatefulWidget {
  final int habitId;

  const YearlySnakeGrid({
    super.key,
    required this.habitId,
  });

  @override
  ConsumerState<YearlySnakeGrid> createState() => _YearlySnakeGridState();
}

class _YearlySnakeGridState extends ConsumerState<YearlySnakeGrid> {
  final int columnCount = 26;
  bool _isLinearView = true;

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitNotifierProvider);

    return habitsAsync.when(
      data: (habits) {
        final habit = habits.firstWhere(
          (h) => h.id == widget.habitId,
          orElse: () => Habit()
            ..id = -1
            ..name = 'Deleted Habit'
            ..startDate = DateTime.now()
            ..colorHex = 0
            ..completedDays = [],
          
        );

        // ERROR HANDLING
        if (habit.id == -1) {
          return _buildErrorState("Habit not found");
        }

        final int rowCount = _isLinearView 
          ? (habit.goalDaysPerWeek > 0 ? habit.goalDaysPerWeek : 1) 
          : 7;
        
        //PERFORMANCE OPTIMIZATION
        final completedDateSet = habit.completedDays
            .map((d) => "${d.year}-${d.month}-${d.day}")
            .toSet();

        final DateTime now = DateTime.now();
        final DateTime today = DateTime(now.year, now.month, now.day);
        final String todayKey = "${today.year}-${today.month}-${today.day}";
        final DateTime habitStart = DateTime(habit.startDate.year, habit.startDate.month, habit.startDate.day);
        final DateTime headerAnchor = habitStart.subtract(Duration(days: habitStart.weekday - 1));

        final DateTime activeStart = DateTime(
          habit.startDate.year, 
          habit.startDate.month, 
          habit.startDate.day
        );

        return _buildMainContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggles(),
              const SizedBox(height: 20),

              RepaintBoundary(
                child: _buildGridScroll(
                  rowCount: rowCount,
                  headerAnchor: headerAnchor,
                  content: (col, row) {
                    Color squareColor = Theme.of(context).colorScheme.tertiary.withOpacity(0.05);

                    final DateTime squareDate = headerAnchor.add(Duration(days: (col * 7) + row));
                    final String dateKey = "${squareDate.year}-${squareDate.month}-${squareDate.day}";

                    if (_isLinearView) {
                      // G O A L
                      final DateTime weekStart = headerAnchor.add(Duration(days: col * 7));
                      final DateTime weekEnd = weekStart.add(const Duration(days: 6));

                      // Count how many completions happened ONLY in this specific week
                      final int completionsThisWeek = habit.completedDays.where((d) {
                        final normalized = DateTime(d.year, d.month, d.day);
                        return !normalized.isBefore(weekStart) && !normalized.isAfter(weekEnd);
                      }).length;

                      // Fill the square ONLY if the row index is less than the completions in THIS week
                      if (row < completionsThisWeek) {
                        squareColor = Theme.of(context).colorScheme.tertiary;
                      }
                    } else {
                      // C A L E N D A R
                      final bool isWithinActiveRange = !squareDate.isBefore(activeStart) && !squareDate.isAfter(today);

                      if (isWithinActiveRange) {
                        if (completedDateSet.contains(dateKey)) {
                          final DateTime weekStart = squareDate.subtract(Duration(days: squareDate.weekday - 1));
                          final DateTime weekEnd = weekStart.add(const Duration(days: 6));
                          
                          final weekCompletions = habit.completedDays.where((d) {
                            final normalized = DateTime(d.year, d.month, d.day);
                            return !normalized.isBefore(weekStart) && !normalized.isAfter(weekEnd);
                          }).toList();
                          
                          weekCompletions.sort((a, b) => a.compareTo(b));

                          final int completionIndex = weekCompletions.indexWhere((d) => 
                              d.year == squareDate.year && d.month == squareDate.month && d.day == squareDate.day);

                          if (completionIndex >= habit.goalDaysPerWeek) {
                            squareColor = const Color(0xFFFFD700);
                          } else {
                            squareColor = Theme.of(context).colorScheme.tertiary;
                          }
                        } else if (dateKey == todayKey) {
                          squareColor = Theme.of(context).colorScheme.secondary.withOpacity(0.5);
                        }
                      }
                    }
                    return _buildSquare(squareColor);
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.grey, thickness: 0.5),
              ),
              HabitCalendarView(habit: habit),
            ],
          ),
        );
      },
      
      loading: () => _buildShimmerLoading(),
      error: (err, stack) {
        debugPrint("YearlySnakeGrid Error: $err");
        return _buildErrorState("Error loading streak data.");
      },
    );
  }

  // UI COMPONENTS

  Widget _buildErrorState(String message) {
    return _buildMainContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, color: Theme.of(context).colorScheme.error, size: 48),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: () => ref.invalidate(habitNotifierProvider),
              child: const Text("Retry"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMainContainer({required Widget child}) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridScroll({
    required int rowCount, 
    required DateTime headerAnchor,
    required Widget Function(int col, int row) content
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthHeader(headerAnchor),
            const SizedBox(height: 12),
            ...List.generate(rowCount, (rowIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.5),
                child: Row(
                  children: List.generate(columnCount, (colIndex) => content(colIndex, rowIndex)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSquare(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildToggles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isLinearView = true),
          child: _toggleItem("Goal", _isLinearView),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => setState(() => _isLinearView = false),
          child: _toggleItem("Calendar", !_isLinearView),
        ),
      ],
    );
  }

  Widget _buildMonthHeader(DateTime anchor) {
  final monthLabels = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  int lastMonthShown = -1;
  int lastLabelColumn = -1;

  return Row(
    children: List.generate(columnCount, (i) {
      final date = anchor.add(Duration(days: i * 7));
      final currentMonth = date.month;
      
      bool isNewMonth = currentMonth != lastMonthShown;
      bool hasEnoughSpace = lastLabelColumn == -1 || (i - lastLabelColumn) >= 3;
      
      bool show = isNewMonth && hasEnoughSpace;

      if (show) {
        lastMonthShown = currentMonth;
        lastLabelColumn = i; 
      }

      return SizedBox(
        width: 13, 
        height: 14,
        child: show ? Stack(
          clipBehavior: Clip.none,
          children: [
            const SizedBox(width: 13, height: 14),
            Positioned(
              left: 0,
              top: 0,
              child: Text(
                monthLabels[currentMonth],
                maxLines: 1,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: -0.2,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ) : const SizedBox.shrink(),
      );
    }),
  );
}

  Widget _toggleItem(String label, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey)),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surfaceVariant,
      highlightColor: Theme.of(context).colorScheme.surface,
      child: _buildMainContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 150, height: 35, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
            const SizedBox(height: 20),
            _buildGridScroll(
              rowCount: 5,
              headerAnchor: DateTime.now(),
              content: (col, row) => _buildSquare(Colors.white),
            ),
            const SizedBox(height: 32),
            Container(width: double.infinity, height: 150, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
          ],
        ),
      ),
    );
  }
}