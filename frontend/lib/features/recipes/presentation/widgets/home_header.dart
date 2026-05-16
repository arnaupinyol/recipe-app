import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/design_system/app_logo.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.selectedTab,
    required this.onTabSelected,
    super.key,
  });

  final int selectedTab;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 98,
      child: Column(
        children: [
          const AppLogo(size: 50, showText: false),
          const SizedBox(height: 8),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.brandSecondary),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _HeaderTab(
                      label: 'Per a tu',
                      isSelected: selectedTab == 0,
                      onTap: () => onTabSelected(0),
                      style: textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.brandSecondary.withValues(alpha: 0.45),
                  ),
                  Expanded(
                    child: _HeaderTab(
                      label: 'Seguint',
                      isSelected: selectedTab == 1,
                      onTap: () => onTabSelected(1),
                      style: textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderTab extends StatelessWidget {
  const _HeaderTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.style,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Center(
        child: Text(
          label,
          style: style?.copyWith(
            color: AppColors.brandPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w100,
          ),
        ),
      ),
    );
  }
}
