import 'package:flutter/material.dart';
import 'package:improov/src/data/database/isar_service.dart'; 
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/features/streak/widgets/global_heatmap_grid.dart';
import 'package:improov/src/features/streak/widgets/heatmap_grid.dart';
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
        
        if (habits.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text("Streak")),
            body: const Center(child: Text("No habits yet. Start slaying.")),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text("Streak"),
            actions: [
              TextButton.icon(
                onPressed: () => setState(() => isYearly = !isYearly),
                icon: Icon(isYearly ? Icons.calendar_view_month : Icons.calendar_view_week),
                label: Text(isYearly ? "Monthly" : "Yearly"),
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () => _changeMonth(-1), icon: const Icon(Icons.chevron_left)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
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
              _buildSectionHeader("Total Progress"),
              const SizedBox(height: 8),
              
              //we use habits.first here because 'habit' doesn't exist yet
              GlobalHeatmapGrid(
                key: ValueKey(habits.map((e) => e.completedDays.length).join(',')), // Forces rebuild on change
                habits: habits,
                targetMonth: _selectedMonth,
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              _buildSectionHeader("Individual Habits"),
              const SizedBox(height: 16),
              
              // Here 'habit' is defined within the map scope
              ...habits.map((habit) => Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          habit.name.toUpperCase(), 
                          style: TextStyle(
                            color: Colors.grey[600], 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          )
                        ),
                        Text(
                          "STREAK: ${habit.calculateStreak}", 
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    HeatmapGrid(
                      habit: habit, 
                      targetMonth: _selectedMonth, 
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }
}