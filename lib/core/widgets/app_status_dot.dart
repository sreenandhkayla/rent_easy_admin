import 'package:flutter/material.dart';

class AppStatusDot extends StatelessWidget {
  const AppStatusDot({super.key, required this.color, this.size = 7});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
