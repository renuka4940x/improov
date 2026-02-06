import 'package:flutter/material.dart';

class BuildTitle extends StatelessWidget {
  final String title;

  const BuildTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 50, bottom: 5, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}
