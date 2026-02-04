import 'package:flutter/material.dart';
import 'package:improov/data/database/habit_database.dart';
import 'package:improov/presentation/theme/dark_mode.dart';
import 'package:improov/presentation/theme/light_mode.dart';
import 'package:improov/presentation/theme/theme_provider.dart';
import 'package:improov/presentation/util/page_nav.dart';
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
      theme: lightMode,
    );
  }
}

//domain
//data
//application
//presentation