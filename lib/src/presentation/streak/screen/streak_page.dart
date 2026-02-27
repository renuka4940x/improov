import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:improov/src/core/util/logic/heatmap_engine.dart';
import 'package:improov/src/core/util/provider/calendar_month_provider.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart';
import 'package:improov/src/presentation/streak/widgets/global_calendar/global_calendar_grid.dart';
import 'package:improov/src/presentation/streak/widgets/global_calendar/widgets/habit_audit_sheet.dart';
import 'package:improov/src/presentation/streak/widgets/individual_heatmap/heatmap_grid.dart';
import 'package:improov/src/presentation/streak/widgets/individual_heatmap/yearly_snake_grid.dart';

class StreakPage extends ConsumerStatefulWidget {
  const StreakPage({super.key});

  @override
  ConsumerState<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends ConsumerState<StreakPage> {
  
  //logic is currently monthly-focused
  bool isYearly = false;

  @override
  Widget build(BuildContext context) {
    //habit notifier
    final habitsAsync = ref.watch(habitNotifierProvider);
    final selectedMonth = ref.watch(calendarMonthProvider);

    return habitsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text("Error: $err"))),
      data: (habits) {
        // 5. Use the engine to generate data from the reactive list
        final monthlySnapshots = HeatmapEngine.generateGlobalSnapshot(
          habits: habits,
          targetMonth: selectedMonth,
        );
        
        if (habits.isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.dark
                        ? 'assets/images/dark_mode/doodle_unboxing_dark.svg'
                        : 'assets/images/light_mode/doodle_unboxing.svg',
                      height: 300,
                      width: 300,
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Text(
                    "hmmm no habits yet, wanna start a new one?",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => ref.read(calendarMonthProvider.notifier).changeMonth(-1),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${selectedMonth.month} / ${selectedMonth.year}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () => ref.read(calendarMonthProvider.notifier).changeMonth(1),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Streaks",
                  style: AppStyle.title(context),
                ),
              ),
              const SizedBox(height: 8),
              
              //calendar view
              GlobalCalendarGrid(
                targetMonth: selectedMonth,
                snapshots: monthlySnapshots,
                onDayTap: (date, snapshot) {
                  HabitAuditSheet.show(context, date, snapshot.completedHabits);
                },
              ),

              const SizedBox(height: 16),
              
              //specific habit
              ...habits.map((habit) => GestureDetector(
                onTap: () {
                  showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: '',
                  barrierColor: Colors.black.withOpacity(0.3),
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, anim1, anim2) {
                    return Center(
                      //blur
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: YearlySnakeGrid(habitId: habit.id),
                      ),
                    );
                  },
                );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 36, right: 8, left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 12),
                
                      //name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                           child: Text(
                              "${habit.name[0].toUpperCase()}${habit.name.substring(1)}", 
                              style: AppStyle.title(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                
                          //streak count
                          Row(
                            children: [
                              Icon(Icons.local_fire_department_outlined, color: Colors.grey, size: 18),
                              Text(
                                "${habit.calculateStreak}", 
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                
                      //heatmap grid
                      HeatmapGrid(
                        habit: habit, 
                        targetMonth: selectedMonth, 
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}