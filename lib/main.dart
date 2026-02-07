import 'package:flutter/material.dart';
import 'package:improov/src/data/database/isar_service.dart';
import 'package:improov/src/features/habits/provider/habit_database.dart';
import 'package:improov/src/features/tasks/provider/task_database.dart';
import 'package:improov/src/core/theme/theme_provider.dart';
import 'package:improov/src/core/routing/router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialzing isar database
  await IsarService.init();

  await Future.delayed(const Duration(milliseconds: 100));

  runApp(
    MultiProvider(
      providers: [
        //theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),

        //database providers
        ChangeNotifierProvider(create: (context) => TaskDatabase()..readTask()),
        ChangeNotifierProvider(create: (context) => HabitDatabase()..saveFirstLaunchDate()..readHabits()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: themeProvider.themeData,
    );
  }
}

//domain
//data
//application
//presentation