import 'package:flutter/material.dart';
import 'package:improov/src/data/database/habit_database.dart';
import 'package:improov/src/data/database/task_database.dart';
import 'package:improov/src/presentation/theme/dark_mode.dart';
import 'package:improov/src/presentation/theme/light_mode.dart';
import 'package:improov/src/presentation/theme/theme_provider.dart';
import 'package:improov/src/presentation/util/page_nav.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialzing isar database
  await HabitDatabase.initialize();

  final habitDatabase = HabitDatabase();
  final taskDatabase = TaskDatabase();

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageNav(),
      theme: darkMode,
    );
  }
}

//domain
//data
//application
//presentation