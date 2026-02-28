import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:improov/src/core/widgets/build_row.dart';
import 'package:improov/src/presentation/profile/provider/app_settings_notifier.dart';
import 'package:improov/src/presentation/profile/provider/stats_provider.dart';

class ProfilePage extends ConsumerWidget {
  final bool isPro;
  const ProfilePage({super.key, this.isPro = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //new Stats provider
    final statsAsync = ref.watch(globalStatsProvider);
    final settingsAsync = ref.watch(appSettingsNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 200),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                children: [
                  settingsAsync.when(
                    data: (settings) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Yoo, ${settings.nickname ?? 'mate'}!",
                          style: AppStyle.title(context),
                        ),
                        const Spacer(),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_horiz),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) {
                            if (value == 'edit') _showEditNicknameDialog(context, ref);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem<String>(
                              value: 'edit',
                              height: 36,
                              child: Row(
                                children: [
                                  Text("Edit"), 
                                  Spacer(), 
                                  Icon(
                                    Icons.edit, 
                                    size: 18
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    loading: () => const Text("Loading..."),
                    error: (err, stack) => const Text("Yoo, mate!"),
                  ),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  Text("Achievements:", style: AppStyle.title(context)),

                  //build Stats Cards
                  statsAsync.when(
                    data: (stats) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                          context,
                          iconData: Icons.local_fire_department_outlined,
                          label: "Best Streak",
                          value: "${stats['bestStreak']}",
                        ),
                        _buildStatCard(
                          context,
                          iconData: Icons.calendar_today_outlined,
                          label: "Tasks Done",
                          value: "${stats['totalTasksCompleted']}",
                        ),
                      ],
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Text("Error: $err"),
                  ),
                  
                  Divider(color: Colors.grey.withValues(alpha: 0.5)),

                  settingsAsync.when(
                    data: (settings) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => ref.read(appSettingsNotifierProvider.notifier).toggleTheme(),
                        child: BuildRow(
                          label: "Dark Mode",
                          isBold: true,
                          trailing: Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: settings.isDarkMode,
                              activeTrackColor: Theme.of(context).colorScheme.tertiary,
                              onChanged: (_) => ref.read(appSettingsNotifierProvider.notifier).toggleTheme(),
                            ),
                          ),
                        ),
                      ),
                    ), 
                    loading: () => const SizedBox.shrink(),
                    error: (err, stack) => const SizedBox.shrink(),
                  ),

                  Divider(color: Colors.grey.withValues(alpha: 0.5)),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () => context.pushNamed('settings'),
                      child: BuildRow(
                        label: "Settings", 
                        trailing: Row(
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                            ),
                          ],
                        ),
                        isBold: true,
                      ),
                    ),
                  ),

                  Divider(color: Colors.grey.withValues(alpha: 0.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //stats card
  Widget _buildStatCard(
    BuildContext context, {
      required IconData iconData, 
      required String label, 
      required String value
    }
  ) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(iconData),
                const SizedBox(width: 8),
                Text(value, style: AppStyle.title(context)),
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
  
  // 
  void _showEditNicknameDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
  
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        title: Text(
          "What should we call you?", 
          style: AppStyle.title(context),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "your nickname~",
            hintStyle: TextStyle(
              fontStyle: FontStyle.italic,
            )
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(appSettingsNotifierProvider.notifier)
                .updateNickname(controller.text);
              
              Navigator.pop(context);
            },
            child: Text(
              "Save", 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary
              ),
            ),
          ),
        ],
      ),
    );
  }
}