import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/features/notifications/notification_service.dart';
import 'package:improov/src/presentation/settings/provider/app_settings_notifier.dart';
import 'package:flutter/services.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  void _testNotification() async {
    final service = NotificationService();
    
    await service.requestPermissions();

    await service.showNotification(
      id: 999,
      title: "Yoo!",
      body: "This is a notification from Improov",
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsNotifierProvider);
    
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

                  //haptic Feedback Toggle
                  _buildToggleTile(
                    title: "Haptic Feedback",
                    subtitle: "Satisfying vibrations on interaction",
                    icon: Icons.vibration,
                    value: settings.hapticsEnabled,
                    onChanged: (val) {
                      ref.read(appSettingsNotifierProvider.notifier).toggleHaptics();
                      if (val) HapticFeedback.mediumImpact();
                    },
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
                      _testNotification();
                      ref.read(appSettingsNotifierProvider.notifier).toggleNotifications();
                    },
                  ),
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
              onTap: () { /* Handle export */ },
            ),
        
            _buildActionTile(
              title: "Delete Progress",
              subtitle: "Permanently wipe all data",
              icon: Icons.delete_outlined,
              isDestructive: true,
              onTap: () { /* Show confirmation dialog */ },
            ),

            _buildSectionHeader("About"),

            _buildActionTile(
              title: "About Improov",
              subtitle: "Learn more about the app and team",
              icon: Icons.info_outline_rounded,
              onTap: () {
                // We use a separate function to show the dialog so we can wrap the theme
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        // This targets the "VIEW LICENSES" and "CLOSE" buttons specifically
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.9), // Your brand color
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
                "Improov v1.0.0",
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
            onTap: onTap,
          ),
          Divider(color: Colors.grey.withValues(alpha: 0.2)),
        ],
      ),
    );
  }
}