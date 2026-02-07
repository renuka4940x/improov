import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improov/src/core/theme/theme_provider.dart';
import 'package:improov/src/features/home/widgets/modals/components/UI/build_row.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
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
    );
  }
}