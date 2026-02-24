import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improov/src/core/constants/app_style.dart';
import 'package:improov/src/core/theme/theme_provider.dart';
import 'package:improov/src/features/home/widgets/modals/components/UI/build_row.dart';
import 'package:improov/src/features/profile/provider/settings_provider.dart';
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
                padding: const EdgeInsets.all(30),
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
                  const Divider(color: Colors.grey,),

                  //theme toggle button
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.read<ThemeProvider>().toggleTheme(),
                    child: BuildRow(
                      label: "Dark Mode", 
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
}