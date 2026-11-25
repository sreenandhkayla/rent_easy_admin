import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/images/app_images.dart';
import '../../resources/strings/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../app_brand_logo.dart';
import '../app_initials_avatar.dart';
import '../app_sidebar_item.dart';
import 'admin_section.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.selected,
    required this.isCollapsed,
    required this.badgeCounts,
    required this.onToggleCollapsed,
    required this.onSelect,
    required this.onLogout,
  });

  final AdminSection selected;
  final bool isCollapsed;
  final Map<AdminSection, int> badgeCounts;
  final VoidCallback onToggleCollapsed;
  final ValueChanged<AdminSection> onSelect;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: isCollapsed
          ? AppTheme.sidebarCollapsedWidth
          : AppTheme.sidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        right: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool compact =
                isCollapsed ||
                constraints.maxWidth < AppTheme.sidebarItemWidth + 16;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: compact
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  _SidebarHeader(compact: compact, onToggle: onToggleCollapsed),
                  const SizedBox(height: 28),
                  if (!compact)
                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 10),
                      child: Text(
                        AppStrings.menuLabel,
                        style: AppTextStyles.overline,
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final AdminSection section
                              in AdminSection.values)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: AppSidebarItem(
                                icon: section.icon,
                                svgIcon: section.svgIcon,
                                label: section.label,
                                isSelected: section == selected,
                                isCollapsed: compact,
                                badgeCount: badgeCounts[section],
                                onTap: () => onSelect(section),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 32, color: AppColors.divider),
                  _ProfileTile(compact: compact),
                  const SizedBox(height: 8),
                  AppSidebarItem(
                    icon: Icons.logout,
                    label: AppStrings.logOut,
                    isCollapsed: compact,
                    onTap: onLogout,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader({required this.compact, required this.onToggle});

  final bool compact;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final Widget toggle = IconButton(
      onPressed: onToggle,
      tooltip: compact ? AppStrings.expandSidebar : AppStrings.collapseSidebar,
      style: IconButton.styleFrom(
        side: const BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        minimumSize: const Size.square(30),
        fixedSize: const Size.square(30),
        padding: EdgeInsets.zero,
      ),
      icon: SvgPicture.asset(
        AppImages.adminConsoleIcon,
        width: 18,
        height: 18,
        colorFilter: const ColorFilter.mode(
          AppColors.textPrimary,
          BlendMode.srcIn,
        ),
      ),
    );
    if (compact) {
      return Column(
        children: [
          const AppBrandLogo(showText: false, size: 36),
          const SizedBox(height: 12),
          toggle,
        ],
      );
    }
    return Row(
      children: [
        const Expanded(child: AppBrandLogo(size: 36)),
        toggle,
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    const AdminProfile profile = AdminProfile.current;
    final Widget avatar = AppInitialsAvatar(name: profile.name);
    if (compact) {
      return Tooltip(message: profile.name, child: avatar);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          avatar,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.name, style: AppTextStyles.titleSmall),
                Text(profile.role, style: AppTextStyles.meta),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
