import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyStatePage extends StatelessWidget {
  const EmptyStatePage({super.key});

  @override
  Widget build(BuildContext context) {
    //checking if theme is dark
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 50),
          
          // Habits Header
          const Text(
            "Habits",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1),
          const Text(
            "none, for now~", 
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 40),

          // Tasks Header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tasks",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(thickness: 1),

          const SizedBox(height: 50),

          // The Illustration
          Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  isDark
                  ? 'assets/images/dark_mode/doodle_laying_dark.svg'
                  : 'assets/images/light_mode/doodle_laying.svg', 
                  height: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  "tap + to start something new!",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}