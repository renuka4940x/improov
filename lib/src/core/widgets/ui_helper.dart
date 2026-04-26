import 'package:flutter/material.dart';

void showImproovToast(BuildContext context, String message, {bool isSuccess = true}) {
  //Create the OverlayEntry
  OverlayEntry? overlayEntry;
  
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50,
      left: 24,
      right: 24,
      child: Material(
        color: Theme.of(context).colorScheme.secondary,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSuccess 
              ? Colors.green.shade300 
              : Colors.red.shade300,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26, 
                blurRadius: 10, 
                offset: Offset(0, 4)
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                isSuccess 
                  ? Icons.check_circle 
                  : Icons.error, 
                color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.5)
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary, 
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // 2. Insert into the Overlay
  Overlay.of(context).insert(overlayEntry);

  // 3. Remove it after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry?.remove();
  });
}