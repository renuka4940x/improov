import 'package:flutter/material.dart';
import 'package:improov/src/data/database/habit_database.dart';
import 'package:improov/src/data/database/task_database.dart';
import 'package:improov/src/presentation/components/Tiles/habit_tile.dart';
import 'package:improov/src/presentation/components/Tiles/task_tile.dart';
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
          
          //empty state
          if (habitDatabase.currentHabits.isEmpty && taskDatabase.currentTasks.isEmpty)
            const SliverToBoxAdapter(child: EmptyStatePage(),),

          //habit section
          if (habitDatabase.currentHabits.isNotEmpty) ...[
            const SliverToBoxAdapter(
              child: FilledStateHome(title: "Habits")
            ),

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
              ),
            ),
          ],

          //task section
          if (taskDatabase.currentTasks.isNotEmpty) ...[
            const SliverToBoxAdapter(
              child: FilledStateHome(
                title: "Tasks",
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final task = taskDatabase.currentTasks[index];
                  return TaskTile(
                    task: task,
                    isCompleted: task.isCompleted,
                    onChanged: (val) {
                      taskDatabase.updateTaskCompletion(task.id);
                    },
                  );
                },
                childCount: taskDatabase.currentTasks.length,
              ),
            ),
          ],

          //padding to not let fab cover last item
          const SliverToBoxAdapter(child: SizedBox(height: 70),),
        ],
      ),
    );
  }
}