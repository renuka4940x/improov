import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:improov/src/core/util/logic/heatmap_engine.dart';
import 'package:improov/src/data/database/isar_service.dart'; 
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/features/streak/widgets/global_calendar/global_calendar_grid.dart';
import 'package:improov/src/features/streak/widgets/global_calendar/widgets/day_audit_sheet.dart';
import 'package:improov/src/features/streak/widgets/individual_heatmap/heatmap_grid.dart';
import 'package:improov/src/features/streak/widgets/individual_heatmap/yearly_snake_grid.dart';
import 'package:isar/isar.dart';

class StreakPage extends StatefulWidget {
  const StreakPage({super.key});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  
  //logic is currently Monthly-focused
  bool isYearly = false; 
  late Stream<List<Habit>> _habitStream;

  @override
  void initState() {
    super.initState();
    _habitStream = IsarService.db.habits.where().build().watch(fireImmediately: true);
  }

  void _changeMonth(int increment) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + increment, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Habit>>(
      stream: _habitStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final habits = snapshot.data ?? [];

        final monthlySnapshots = HeatmapEngine.generateGlobalSnapshot(
          habits: habits,
          targetMonth: _selectedMonth,
        );
        
        if (habits.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text("Streak")),
            body: const Center(child: Text("No habits yet. Start slaying.")),
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
                    IconButton(onPressed: () => _changeMonth(-1), icon: const Icon(Icons.chevron_left)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${_selectedMonth.month} / ${_selectedMonth.year}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(onPressed: () => _changeMonth(1), icon: const Icon(Icons.chevron_right)),
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
                  "All", 
                  style: GoogleFonts.jost(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  )
                ),
              ),
              const SizedBox(height: 8),
              
              //calendar view
              GlobalCalendarGrid(
                targetMonth: _selectedMonth,
                snapshots: monthlySnapshots,
                onDayTap: (date, snapshot) {
                  DayAuditSheet.show(context, date, snapshot.completedHabits);
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
                          Text(
                            "${habit.name[0].toUpperCase()}${habit.name.substring(1)}", 
                            style: GoogleFonts.jost(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            )
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
                        targetMonth: _selectedMonth, 
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