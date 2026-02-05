import 'package:flutter/material.dart';

class BuildCross extends StatelessWidget {
  const BuildCross({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 25,
        child: Icon(
          Icons.close_rounded,
          color: Theme.of(context).colorScheme.inversePrimary,
          size: 35,
        ),
      ),
    );
  }
}