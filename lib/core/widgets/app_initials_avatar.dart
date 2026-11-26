import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppInitialsAvatar extends StatelessWidget {
  const AppInitialsAvatar({
    super.key,
    required this.name,
    this.size = 36,
    this.isMuted = false,
    this.initialsStyle,
  });

  final String name;
  final double size;
  final bool isMuted;
  final TextStyle? initialsStyle;

  String get _initials {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isMuted ? AppColors.iconCircle : AppColors.ink,
        shape: BoxShape.circle,
      ),
      child: Text(
        _initials,
        style:
            initialsStyle ??
            (isMuted
                ? AppTextStyles.avatarInitialsMuted
                : AppTextStyles.avatarInitials),
      ),
    );
  }
}
