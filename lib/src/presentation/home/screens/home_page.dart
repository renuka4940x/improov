import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart';
import 'package:improov/src/features/habits/widgets/habit_tile.dart';
import 'package:improov/src/features/tasks/widget/task_tile.dart';
import 'package:improov/src/core/widgets/build_title.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch notifiers
    final habitsAsync = ref.watch(habitNotifierProvider);
    final tasksAsync = ref.watch(taskNotifierProvider);

    final hasHabits = habitsAsync.value?.isNotEmpty ?? false;
    final hasTasks = tasksAsync.value?.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            //show the Habit Header
            const SliverToBoxAdapter(
              child: BuildTitle(
                title: "Habits",
              ),
            ),
        
            //habit section
            habitsAsync.when(
              data: (habits) => habits.isEmpty
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
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final habit = habits[index];
                      return HabitTile(
                        habit: habit,
                        onChanged: (val) => ref
                          .read(habitNotifierProvider.notifier)
                          .updateHabitCompletion(habit.id, val ?? false),
                      );
                    }, 
                    childCount: habits.length
                  ),
                ),
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator())
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: Text("Error: $err"),
              ),
            ),
        
            const SliverToBoxAdapter(
              child: BuildTitle(
                title: "Tasks"
              ),
            ),
        
            //task section
            tasksAsync.when(
              data: (tasks) => tasks.isEmpty
                ? const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25, bottom: 20),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                      final task = tasks[index];
                      return TaskTile(
                        task: task,
                        onChanged: (val) => ref
                          .read(taskNotifierProvider.notifier)
                          .updateTaskCompletion(task.id, val ?? false),
                        isCompleted: task.isCompleted,
                      );
                    }, 
                    childCount: tasks.length,
                  ),
                ),
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (err, _) => SliverToBoxAdapter(child: Text("Error: $err")),  
            ),
        
            //svg section
            if (habitsAsync.hasValue &&
                tasksAsync.hasValue &&
                habitsAsync.value!.isEmpty &&
                tasksAsync.value!.isEmpty)
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

            if (hasHabits || hasTasks) 
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
          ],
        ),
      ),
    );
  }
}
