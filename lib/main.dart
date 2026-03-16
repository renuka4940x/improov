import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/dataconnect_generated/generated.dart';
import 'package:improov/src/presentation/settings/provider/app_settings_notifier.dart';
import 'package:improov/src/core/routing/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ExampleConnector.instance.dataConnect.useDataConnectEmulator('192.168.29.254', 9399);

  const bool useEmulator = true;
  
  if (useEmulator) {
    print("RAHHHHHH! Data Connect Emulator is Live!");
  }

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