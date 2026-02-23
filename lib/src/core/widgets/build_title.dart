import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            style: GoogleFonts.jost(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}
