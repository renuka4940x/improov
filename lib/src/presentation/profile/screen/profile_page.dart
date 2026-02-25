import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:improov/src/core/theme/theme_provider.dart';
import 'package:improov/src/presentation/home/widgets/modals/components/UI/build_row.dart';
import 'package:improov/src/presentation/profile/provider/settings_provider.dart';
import 'package:improov/src/presentation/profile/provider/stats_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final bool isPro;
  const ProfilePage({
    super.key,
    this.isPro = false,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 200,),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Yoo, ${context.watch<SettingsProvider>().nickname ?? 'mate'}!",
                        style: AppStyle.title(context),
                      ),
                      const Spacer(), // Pushes the menu to the right
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_horiz), // Your meatball icon
                        onSelected: (value) {
                          if (value == 'edit') {
                            // Open your Edit Nickname dialog here
                            _showEditNicknameDialog(context);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Text("Edit"),
                                Spacer(),
                                Icon(Icons.edit, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ), 
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  
                  const SizedBox(height: 16),

                  //achievements
                  Text(
                    "Achievements:",
                    style: AppStyle.title(context),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(
                        iconData: Icons.local_fire_department_outlined,
                        label: "Best Streak",
                        value: "${context.watch<StatsProvider>().bestStreak}"
                      ),
                      _buildStatCard(
                        iconData: Icons.calendar_today_outlined,
                        label: "Tasks Done",
                        value: "${context.watch<StatsProvider>().totalTasksCompleted}"
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey.withValues(alpha: 0.5)),
                  
                  //theme toggle button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.read<ThemeProvider>().toggleTheme(),
                      child: BuildRow(
                        label: "Dark Mode",
                        isBold: true,
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: context.watch<ThemeProvider>().isDarkMode,
                            activeTrackColor: Theme.of(context).colorScheme.tertiary, 
                            onChanged: (value) {
                              context.read<ThemeProvider>().toggleTheme();
                            }
                          ),
                        )
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
  
  void _showEditNicknameDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "What should we call you?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
              context.read<SettingsProvider>().updateNickname(controller.text);
              Navigator.pop(context);
            },
            child: Text(
              "Save", 
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required IconData iconData, required String label, required String value}) {
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
                Text(
                  value, 
                  style: AppStyle.title(context)
                ),
              ],
            ), // Your custom font style
            const SizedBox(height: 4),
            Text(
              label, 
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}