import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:improov/src/data/database/isar_service.dart';
import 'package:improov/src/features/habits/provider/habit_database.dart';
import 'package:improov/src/features/tasks/provider/task_provider.dart';
import 'package:improov/src/presentation/profile/provider/app_settings_database.dart';
import 'package:improov/src/presentation/profile/provider/settings_provider.dart';
import 'package:improov/src/presentation/profile/provider/stats_provider.dart';
import 'package:improov/src/features/tasks/provider/task_database.dart';
import 'package:improov/src/core/theme/theme_provider.dart';
import 'package:improov/src/core/routing/router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialzing isar database
  await IsarService.init();

  await Future.delayed(const Duration(milliseconds: 100));

  final settingsDatabase = AppSettingsDatabase();
  final habitDatabase = HabitDatabase();
  final taskDataase = TaskDatabase();
  final appSettingsDatabase = AppSettingsDatabase();
  final isarService = IsarService();

  runApp(
    MultiProvider(
      providers: [
        //theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider(appSettingsDatabase)),

        //database providers
        ChangeNotifierProvider(create: (context) => taskDataase..readTask()),
        ChangeNotifierProvider(create: (context) => habitDatabase
          ..saveFirstLaunchDate()
          ..checkWeeklyReset()
          ..readHabits()
        ),
        ChangeNotifierProvider(create: (context) => SettingsProvider(settingsDatabase)),
        ChangeNotifierProvider(create: (_) => StatsProvider(habitDatabase, taskDataase)),
        ChangeNotifierProvider(create: (_) => TaskProvider(isarService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<ThemeProvider>().themeData;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: currentTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(currentTheme.textTheme),
        primaryTextTheme: GoogleFonts.jostTextTheme(currentTheme.primaryTextTheme),
      ),
      builder: (context, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 5),
          child: child!,
        );
      },
    );
  }
}