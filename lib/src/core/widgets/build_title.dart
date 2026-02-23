import 'package:flutter/material.dart';
import 'package:improov/src/core/constants/app_style.dart';

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
            style: AppStyle.title(context),
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}
