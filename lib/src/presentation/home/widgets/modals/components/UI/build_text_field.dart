import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isItalic;
  final bool isDescription;

  const BuildTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.isItalic = false,
    this.isDescription = false,
  });

  @override
  Widget build(BuildContext context) {
    final int limit = isDescription ? 250 : 50;

    return Column(
      children: [
        CupertinoTextField(
          maxLength: limit,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
            fontStyle: isItalic 
              ? FontStyle.italic 
              : FontStyle.normal,
            fontWeight: isItalic 
              ? FontWeight.normal 
              : FontWeight.bold,
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 16,
          ),
        ),

        //word count
        Align(
          alignment: Alignment.centerRight,
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              final int currentLength = controller.text.length;
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '$currentLength / $limit',
                  style: TextStyle(
                    fontSize: 10,
                    color: currentLength >= limit 
                        ? Colors.red.shade300
                        : Colors.grey.withOpacity(0.6),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}