import 'package:flutter/material.dart';
import 'package:improov/src/core/constants/app_colors.dart';

class ConstellationWidget extends StatelessWidget {
  final int count;
  final bool hasOrigin;

  const ConstellationWidget({super.key, required this.count, required this.hasOrigin});

  @override
  Widget build(BuildContext context) {
    int dotsToShow = count.clamp(0, 3);
    
    return Wrap(
      spacing: 2,
      children: List.generate(dotsToShow, (i) {
        bool isOrigin = hasOrigin && i == 0;
        return Container(
          width: 4, height: 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOrigin 
              ? AppColors.slayGreen 
              : AppColors.lightTertiary,
          ),
        );
      }),
    );
  }
}