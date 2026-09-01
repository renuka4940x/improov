import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart';
import 'package:improov/src/features/habits/widgets/habit_tile.dart';
import 'package:improov/src/features/tasks/widget/task_tile.dart';
import 'package:improov/src/core/widgets/build_title.dart';
import 'package:improov/src/data/models/habit/habit.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // Toggle states for the accordions
  bool _showAllHabits = false;
  bool _showAllTasks = false;

  // Helper to check if a habit is completed today so we can filter the list
  bool _isHabitCompletedToday(Habit habit) {
    final DateTime today = DateTime.now();
    return habit.completedDays.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitProvider);
    final tasksAsync = ref.watch(taskProvider);

    final hasHabits = habitsAsync.value?.isNotEmpty ?? false;
    final hasTasks = tasksAsync.value?.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // --- HABIT HEADER WITH ACCORDION & SUB-DIVIDER ---
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BuildTitle(title: "Habits"),
                        if (hasHabits)
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: IconButton(
                              onPressed: () {
                                setState(() => _showAllHabits = !_showAllHabits);
                              },
                              icon: Icon(
                                _showAllHabits
                                    ? PhosphorIconsRegular.caretUp
                                    : PhosphorIconsRegular.caretDown,
                                color: Colors.grey.shade600,
                                size: 20,
                              ),
                              splashRadius: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.3),
                      thickness: 1,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),

            // --- HABIT SECTION ---
            habitsAsync.when(
              data: (habits) {
                if (habits.isEmpty) {
                  return const SliverToBoxAdapter(
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
                  );
                }

                // Filter logic
                final incompleteHabits = habits.where((h) => !_isHabitCompletedToday(h)).toList();
                final displayedHabits = _showAllHabits ? habits : incompleteHabits;

                if (displayedHabits.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25, bottom: 20),
                      child: Text(
                        "all done for today!",
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final habit = displayedHabits[index];
                    return HabitTile(
                      habit: habit,
                      onChanged: (val) => ref
                          .read(habitProvider.notifier)
                          .updateHabitCompletion(habit.id, val ?? false),
                    );
                  }, childCount: displayedHabits.length),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => SliverToBoxAdapter(child: Text("Error: $err")),
            ),

            // --- TASK HEADER WITH ACCORDION & SUB-DIVIDER ---
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BuildTitle(title: "Tasks"),
                      if (hasTasks)
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: IconButton(
                            onPressed: () {
                              setState(() => _showAllTasks = !_showAllTasks);
                            },
                            icon: Icon(
                              _showAllTasks
                                  ? PhosphorIconsRegular.caretUp
                                  : PhosphorIconsRegular.caretDown,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                            splashRadius: 20,
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.3),
                      thickness: 1,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),

            // --- TASK SECTION ---
            tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25, bottom: 20),
                    ),
                  );
                }

                // Filter logic
                final incompleteTasks = tasks.where((t) => !t.isCompleted).toList();
                final displayedTasks = _showAllTasks ? tasks : incompleteTasks;

                if (displayedTasks.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25, bottom: 20),
                      child: Text(
                        "all tasks cleared!",
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final task = displayedTasks[index];
                    return TaskTile(
                      key: ValueKey(task.id),
                      task: task,
                      onChanged: (val) => ref
                          .read(taskProvider.notifier)
                          .updateTaskCompletion(task.id, val ?? false),
                      isCompleted: task.isCompleted,
                    );
                  }, childCount: displayedTasks.length),
                );
              },
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (err, _) => SliverToBoxAdapter(child: Text("Error: $err")),
            ),

            // --- EMPTY STATE SVG SECTION ---
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

            // Padding to not let FAB cover last item
            if (hasHabits || hasTasks)
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}