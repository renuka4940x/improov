import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/data/database/isar_service.dart';
import 'package:improov/src/features/notifications/notification_service.dart';
import 'package:improov/src/features/services/subscription_services.dart';
import 'package:improov/src/presentation/settings/provider/app_settings_notifier.dart';
import 'package:improov/src/core/routing/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  //isar init
  final isarService = await IsarService.init();

  //firebase init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //notification initialization
  final notificationService = NotificationService();
  await notificationService.initNotification();
  await notificationService.requestPermissions();

  notificationService.listenToHabitChanges(isarService.db);
  notificationService.listenToTaskChanges(isarService.db);

  //RevenueCat init
  await SubscriptionService.init(isarService.db);

  await SubscriptionService.syncSubscriptionToIsar(isarService.db);

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
    final router = ref.watch(routerProvider);

    //handles the state
    return settingsAsync.when(
      data: (settings) {
        final currentTheme = settings.themeData;

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
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