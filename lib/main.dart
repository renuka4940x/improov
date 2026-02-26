import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/presentation/profile/provider/app_settings_notifier.dart';
import 'package:improov/src/core/routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsNotifierProvider);

  //handles the state
  return settingsAsync.when(
    data: (settings) {
      final currentTheme = settings.themeData;

      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: currentTheme.copyWith(
          textTheme: GoogleFonts.interTextTheme(currentTheme.textTheme),
          primaryTextTheme: GoogleFonts.jostTextTheme(currentTheme.primaryTextTheme),
        ),
        builder: (context, child) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 10),
          child: child!,
        ),
      );
    },

    loading: () => const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator()
        ),
      ),
    ),

    error: (err, stack) => MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Fatal Error: $err"))
      )
    ),
  );
  }
}