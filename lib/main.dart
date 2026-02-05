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
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    MultiProvider(
      providers: [
        //theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),

        //database providers
        ChangeNotifierProvider(create: (context) => TaskDatabase()),
        ChangeNotifierProvider(create: (context) => HabitDatabase()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //start initial fetch of data
    Provider.of<TaskDatabase>(context, listen: false).readTask();
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageNav(),
      theme: lightMode,
    );
  }
}

//domain
//data
//application
//presentation