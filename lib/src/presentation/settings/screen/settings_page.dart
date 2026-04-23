import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/data/provider/subscription_provider.dart';
import 'package:improov/src/features/services/subscription_services.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:isar/isar.dart';

import 'package:improov/src/features/notifications/notification_service.dart';
import 'package:improov/src/presentation/settings/provider/app_settings_notifier.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart'; 
import 'package:improov/src/presentation/profile/provider/stats_provider.dart';


class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  // CSV EXPORT LOGIC
  Future<void> exportDataAsCSV() async {
    try {
      // Grab current habits from Riverpod
      final habitsAsync = ref.read(habitNotifierProvider);
      
      // Safety check: wait for data if it's currently loading
      final habits = habitsAsync.value ?? [];
      
      if (habits.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No data to export yet!")),
        );
        return;
      }

      // Build the CSV String
      StringBuffer csvData = StringBuffer();
      csvData.writeln("Habit Name,Goal Days/Week,Start Date,Total Completed Days");

      for (var habit in habits) {
        final startDateStr = "${habit.startDate.year}-${habit.startDate.month}-${habit.startDate.day}";
        csvData.writeln("${habit.name},${habit.goalDaysPerWeek},$startDateStr,${habit.completedDays.length}");
      }

      // Save to a temporary file
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/improov_data.csv";
      final file = File(path);
      await file.writeAsString(csvData.toString());

      // Open the native Share Sheet
      await Share.shareXFiles([XFile(path)], text: 'My Improov Habit Data');
      
    } catch (e) {
      debugPrint("Export Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Export failed: $e"), 
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  //DELETE ALL DATA LOGIC
  void showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Wipe All Data?", 
          style: TextStyle(
            color: Colors.red.shade300, 
            fontWeight: FontWeight.bold
          )
        ),
        content: const Text(
          "This will permanently delete all your habits, tasks, and streak history. This action cannot be undone.\n\nAre you absolutely sure?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel", 
              style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade300, 
            ),
            onPressed: () async {
              // Close Dialog
              Navigator.pop(context);
              
              // Nuke the Isar Database
              final isar = Isar.getInstance('improov_db');
              if (isar != null) {
                await isar.writeTxn(() async {
                  await isar.clear();
                });
              }

              // Force Riverpod to reload the empty UI
              ref.invalidate(habitNotifierProvider);
              ref.invalidate(taskNotifierProvider);
              ref.invalidate(globalStatsProvider);
              
              if (!context.mounted) return; 
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All data has been wiped.")),
              );
            },
            child: const Text(
              "Delete", 
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold
              )
            ),
          ),
        ],
      ),
    );
  }

  //DELETE THE ACCOUNT
  void showAccountDeletionDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Delete Account?", 
        style: TextStyle(
          color: Colors.red.shade300, 
          fontWeight: FontWeight.bold)
      ),
      content: const Text(
        "This will permanently delete your Improov account and all synced data. "
        "Your premium subscription (if any) must be cancelled manually via the Play Store/App Store.\n\n"
        "This cannot be undone. Proceed?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade300
          ),
          onPressed: () async {
            try {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                // Delete the Auth User
                await user.delete();
                
                // Clear local Isar data
                final isar = Isar.getInstance('improov_db');
                if (isar != null) {
                  await isar.writeTxn(() => isar.clear());
                }

                if (!context.mounted) return; 

                Navigator.pop(context);
                context.go('/login');
              }
            } on FirebaseAuthException catch (e) {
              if (e.code == 'requires-recent-login') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Please log out and log back in to verify it's you, then try deleting again."
                    )
                  ),
                );
              }
            }
          },
          child: const Text(
            "Delete Account", 
            style: TextStyle(color: Colors.white)
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsNotifierProvider);
    
    final isPremium = ref.watch(premiumProvider);
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Settings", 
          style: AppStyle.title(context)
        ),
        centerTitle: false,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: ListView(
          children: [
            //preference section
            _buildSectionHeader("Preferences"),
        
            //theme toggle
            settingsAsync.when(
              data: (settings) => Column(
                children: [

                  //theme Toggle
                  _buildToggleTile(
                    title: "Dark Mode",
                    subtitle: "Easier on the eyes at night",
                    icon: Icons.dark_mode_outlined,
                    value: settings.isDarkMode,
                    onChanged: (_) => ref.read(appSettingsNotifierProvider.notifier).toggleTheme(),
                  ),

                  //notifications Toggle
                  _buildToggleTile(
                    title: "Notifications",
                    subtitle: "Get a nudge to stay on track",
                    icon: Icons.notifications_none_outlined,
                    value: settings.notifyHabitReminders, 
                    onChanged: (val) async {
                      if (val) {
                        // Trigger the system permission dialog if turning ON
                        await NotificationService().requestPermissions();
                      }
                      ref.read(appSettingsNotifierProvider.notifier).toggleNotifications();
                    },
                  ),

                  //default reminder time selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Default Reminder Time",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.9),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "When should we remind you for habits?",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // The Segmented Button
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<int>(
                            segments: const [
                              ButtonSegment<int>(
                                value: 9,
                                label: Text('Morning'),
                                icon: Icon(Icons.wb_sunny_outlined, size: 18),
                              ),
                              ButtonSegment<int>(
                                value: 15,
                                label: Text('Afternoon'),
                                icon: Icon(Icons.cloud_outlined, size: 18),
                              ),
                              ButtonSegment<int>(
                                value: 21,
                                label: Text('Night'),
                                icon: Icon(Icons.nights_stay_outlined, size: 18),
                              ),
                            ],

                            //read from isar
                            selected: {settings.defaultReminderHour},
                            onSelectionChanged: (Set<int> newSelection) {
                              // Saves to Isar
                              ref.read(appSettingsNotifierProvider.notifier)
                                 .updateDefaultReminderHour(newSelection.first);
                            },

                            style: SegmentedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              selectedBackgroundColor: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2),
                              selectedForegroundColor: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Divider(color: Colors.grey.withValues(alpha: 0.2)),
                ],
              ),
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, stack) => const Text("Error loading settings"),
            ),
            
            //data section
            _buildSectionHeader("Data Management"),
        
            _buildActionTile(
              title: "Export Data",
              subtitle: "Download your habit history as CSV file",
              icon: Icons.download_outlined,
              isProFeature: !isPremium, 
              onTap: isPremium 
                  ? exportDataAsCSV 
                  : () => SubscriptionService.showPaywall(ref),
            ),
        
            _buildActionTile(
              title: "Delete Progress",
              subtitle: "Permanently wipe all data",
              icon: Icons.delete_outlined,
              isDestructive: true,
              onTap: showDeleteConfirmation,
            ),

            _buildActionTile(
              title: "Delete Account",
              subtitle: "Permanently remove your account and cloud data",
              icon: Icons.person_off_outlined,
              isDestructive: true,
              onTap: showAccountDeletionDialog,
            ),

            _buildSectionHeader("About"),

            _buildActionTile(
              title: "About Improov",
              subtitle: "Learn more about the app and team",
              icon: Icons.info_outline_rounded,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.inversePrimary
                              .withValues(alpha: 0.9),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      child: AboutDialog(
                        applicationName: 'Improov',
                        applicationVersion: '1.0.0',
                        applicationIcon: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.auto_awesome, size: 50),
                          ),
                        ),
                        applicationLegalese: "© 2026 Ren's Lab",
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Improov is designed to help you build lasting habits through visual feedback and consistency. Keep pushing your streaks!",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            
            //version section
            const SizedBox(height: 40),
            Center(
              child: Text(
                "Improov v0.1.1.beta",
                style: TextStyle(
                  color: Colors.grey.shade500, 
                  fontSize: 12
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.jost(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.6),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              icon, 
              color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.9)
            ),
            title: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.9),
                fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
              subtitle, 
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              )
            ),
            trailing: Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                value: value,
                activeColor: Theme.of(context).colorScheme.tertiary,
                onChanged: onChanged,
              ),
            ),
          ),
          Divider(color: Colors.grey.withValues(alpha: 0.2)),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
    bool isProFeature = false,
  }) {
    final color = isDestructive 
      ? Colors.red.shade300 
      : Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.9);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: color),
            title: Text(
              title, 
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              )
            ),
            subtitle: Text(
              subtitle, 
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey
              )
            ),
            trailing: isProFeature 
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "PRO", 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary, 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                )
              : null,
            onTap: onTap,
          ),
          Divider(color: Colors.grey.withValues(alpha: 0.2)),
        ],
      ),
    );
  }
}