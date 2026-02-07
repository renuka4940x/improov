import 'package:flutter/material.dart';
import 'package:improov/src/features/habits/provider/habit_database.dart';
import 'package:improov/src/features/tasks/provider/task_database.dart';
import 'package:improov/src/core/theme/dark_mode.dart';
import 'package:improov/src/core/theme/light_mode.dart';
import 'package:improov/src/core/theme/theme_provider.dart';
import 'package:improov/src/core/routing/router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialzing isar database
  await HabitDatabase.initialize();

  await Future.delayed(const Duration(milliseconds: 100));

  final isarInstance = HabitDatabase.isar;

  final habitDatabase = HabitDatabase();
  final taskDatabase = TaskDatabase(isarInstance);

  await habitDatabase.saveFirstLaunchDate();
  await habitDatabase.readHabits();
  await taskDatabase.readTask();

  runApp(
    MultiProvider(
      providers: [
        //theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),

        //database providers
        ChangeNotifierProvider.value(value: taskDatabase,),
        ChangeNotifierProvider.value(value: habitDatabase),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter,
      theme: darkMode,
    );
  }
}

//domain
//data
//application
//presentation