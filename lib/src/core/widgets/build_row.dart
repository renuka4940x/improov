import 'package:flutter/material.dart';
import 'package:improov/src/core/widgets/pro_badge.dart';

class BuildRow extends StatelessWidget {
  final String label;
  final Widget trailing;
  final bool isBold;
  final bool isPro;

  const BuildRow({
    super.key,
    required this.label,
    required this.trailing,
    this.isBold = false,
    this.isPro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold
                ? 18
                : 16,
              fontWeight: isBold
                ? FontWeight.w600
                : FontWeight.w500,
            ),
          ),

          if (isPro) ...[
             SizedBox(
              width: isBold
                ? 24
                : 8,
            ),
            ProBadge(),
          ],
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}