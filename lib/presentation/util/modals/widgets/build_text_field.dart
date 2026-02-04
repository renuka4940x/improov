import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isItalic;

  const BuildTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.isItalic = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary,
            width: 1.0,
          ),
        ),
      ),

      padding: const EdgeInsets.symmetric(vertical: 12),

      placeholderStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        fontWeight: isItalic ? FontWeight.normal : FontWeight.bold,
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary,
        fontSize: 16,
      ),
    );
  }
}