import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static TextStyle title(BuildContext context) {
    return GoogleFonts.jost(
      fontWeight: FontWeight.w600,
      fontSize: 24,
      color: Theme.of(context).colorScheme.inversePrimary,
    );
  }
}