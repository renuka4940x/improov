import 'package:flutter/material.dart';
import 'package:improov/src/core/widgets/pro_badge.dart';

class BuildRow extends StatelessWidget {
  final String label;
  final Widget trailing;
  final bool isPro;

  const BuildRow({
    super.key,
    required this.label,
    required this.trailing,
    this.isPro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),
          ),

          if (isPro) ...[
            const SizedBox(width: 8,),
            ProBadge(),
          ],
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}