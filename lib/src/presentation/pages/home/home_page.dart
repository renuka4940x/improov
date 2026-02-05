import 'package:flutter/material.dart';
import 'package:improov/src/data/database/habit_database.dart';
import 'package:improov/src/data/database/task_database.dart';
import 'package:improov/src/presentation/components/Tiles/habit_tile.dart';
import 'package:improov/src/presentation/pages/home/states/empty_state_home.dart';
import 'package:improov/src/presentation/pages/home/states/filled_state_home.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final habitDatabase = context.watch<HabitDatabase>();
    final taskDatabase = context.watch<TaskDatabase>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          //header
          SliverAppBar(
            expandedHeight: 70,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "I M P R O O V",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              centerTitle: true,
              background: Container(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),

          //empty state
          if (habitDatabase.currentHabits.isEmpty && taskDatabase.currentTasks.isEmpty)
            SliverFillRemaining(
              child: EmptyStateHome(),
            ),

          //habit section
          if (habitDatabase.currentHabits.isNotEmpty) ...[
            FilledStateHome(title: "H A B I T S"),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final habit = habitDatabase.currentHabits[index];
                  return HabitTile(
                    habit: habit,
                    onChanged: (val) => habitDatabase.updateHabitCompletion(habit.id, val ?? false),
                  );
                },
                childCount: habitDatabase.currentHabits.length,
              )
            )
          ]

          //task section
        ],
      ),
    );
  }
}