import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:improov/src/features/habits/provider/habit_database.dart';
import 'package:improov/src/features/tasks/provider/task_database.dart';
import 'package:improov/src/features/habits/widgets/habit_tile.dart';
import 'package:improov/src/features/tasks/widget/task_tile.dart';
import 'package:improov/src/core/widgets/build_title.dart';
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
          //show the Habit Header
          const SliverToBoxAdapter(child: BuildTitle(title: "Habits")),

          //habit section
          habitDatabase.currentHabits.isEmpty
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, bottom: 20),
                    child: Text(
                      "none, for now~",
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final habit = habitDatabase.currentHabits[index];
                    return HabitTile(
                      habit: habit,
                      onChanged: (val) => habitDatabase.updateHabitCompletion(
                        habit.id,
                        val ?? false,
                      ),
                    );
                  }, childCount: habitDatabase.currentHabits.length),
                ),

          const SliverToBoxAdapter(child: BuildTitle(title: "Tasks")),

          //task section
          taskDatabase.currentTasks.isEmpty
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, bottom: 20),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final task = taskDatabase.currentTasks[index];
                    return TaskTile(
                      task: task,
                      onChanged: (val) =>
                          taskDatabase.updateTaskCompletion(task.id, val ?? false),
                      isCompleted: task.isCompleted,
                    );
                  }, childCount: taskDatabase.currentTasks.length),
                ),

          //svg section
          if (habitDatabase.currentHabits.isEmpty &&
              taskDatabase.currentTasks.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'assets/images/dark_mode/doodle_laying_dark.svg'
                          : 'assets/images/light_mode/doodle_laying.svg',
                      height: 200,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "tap + to start something new!",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),

          //padding to not let fab cover last item
          if (habitDatabase.currentHabits.isNotEmpty ||
              taskDatabase.currentTasks.isNotEmpty)
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}
