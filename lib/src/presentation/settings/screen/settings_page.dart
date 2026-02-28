import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDark = true;
  bool _hapticsEnabled = true;
  bool _remindersEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Settings", 
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        centerTitle: false,
        elevation: 0,
      ),

      body: ListView(
        children: [
          //preference section
          _buildSectionHeader("Preferences"),

          _buildToggleTile(
            title: "Dark Mode",
            subtitle: "Easier on the eyes at night",
            icon: Icons.dark_mode_outlined,
            value: _isDark,
            onChanged: (val) => setState(() => _isDark = val),
          ),

          _buildToggleTile(
            title: "Haptic Feedback",
            subtitle: "Satisfying vibrations on interaction",
            icon: Icons.vibration,
            value: _hapticsEnabled,
            onChanged: (val) => setState(() => _hapticsEnabled = val),
          ),

          _buildToggleTile(
            title: "Notification",
            subtitle: "Get a nudge to stay on track",
            icon: Icons.notifications_none_outlined,
            value: _remindersEnabled,
            onChanged: (val) => setState(() => _remindersEnabled = val),
          ),
          
          const Divider(height: 40),
          
          //data section
          _buildSectionHeader("Data Management"),

          _buildActionTile(
            title: "Export Data",
            subtitle: "Download your habit history as JSON",
            icon: Icons.download_outlined,
            onTap: () { /* Handle export */ },
          ),

          _buildActionTile(
            title: "Reset All Progress",
            subtitle: "Permanently wipe all data",
            icon: Icons.delete_forever_outlined,
            isDestructive: true,
            onTap: () { /* Show confirmation dialog */ },
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
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inversePrimary,
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
      child: ListTile(
        leading: Icon(
          icon, 
          color: Theme.of(context).colorScheme.onSurface
        ),
        title: Text(title),
        subtitle: Text(
          subtitle, 
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          )
        ),
        trailing: CupertinoSwitch(
          value: value,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: onChanged,
        ),
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
      : Theme.of(context).colorScheme.inversePrimary;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: Text(
        subtitle, 
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey
        )
      ),
      onTap: onTap,
    );
  }
}