import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final double shift = _controller.value * 3 - 1;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(shift - 1, 0),
            end: Alignment(shift + 1, 0),
            colors: const [
              AppColors.skeleton,
              AppColors.skeletonHighlight,
              AppColors.skeleton,
            ],
            stops: const [0.25, 0.5, 0.75],
          ).createShader(bounds),
          child: child,
        );
      },
    );
  }
}

class AppSkeletonBox extends StatelessWidget {
  const AppSkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 10,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.skeleton,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
