import 'package:flutter/material.dart';
import 'package:improov/theme/dark_mode.dart';
import 'package:improov/theme/light_mode.dart';
import 'package:improov/theme/theme_provider.dart';
import 'package:improov/util/page_nav.dart';
import 'package:provider/provider.dart';

void main() {
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
