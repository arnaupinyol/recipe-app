import 'package:flutter/material.dart';

import '../../../app/assets/app_assets.dart';
import '../../../app/theme/app_colors.dart';
import 'app_asset_icon.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
    this.destinations = const [
      BottomNavigationItem(
        assetIcon: AppAssets.bottomNavigationHomeIcon,
        label: 'Home',
      ),
      BottomNavigationItem(
        assetIcon: AppAssets.bottomNavigationSearchIcon,
        label: 'Buscar',
      ),
      BottomNavigationItem(
        assetIcon: AppAssets.bottomNavigationAddCircleIcon,
        label: 'Crear recepta',
      ),
      BottomNavigationItem(
        assetIcon: AppAssets.bottomNavigationBookmarkIcon,
        label: 'Guardats',
      ),
      BottomNavigationItem(
        assetIcon: AppAssets.bottomNavigationProfileIcon,
        label: 'Perfil',
      ),
    ],
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<BottomNavigationItem> destinations;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.brandSecondary)),
      ),
      child: SizedBox(
        height: 77,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final indexed in destinations.indexed)
              _NavigationButton(
                item: indexed.$2,
                isSelected: selectedIndex == indexed.$1,
                onTap: () => onDestinationSelected(indexed.$1),
              ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigationItem {
  const BottomNavigationItem({
    required this.label,
    this.icon,
    this.selectedIcon,
    this.assetIcon,
    this.selectedAssetIcon,
  }) : assert(icon != null || assetIcon != null);

  final IconData? icon;
  final IconData? selectedIcon;
  final String? assetIcon;
  final String? selectedAssetIcon;
  final String label;
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final BottomNavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: SizedBox(
          width: 48,
          height: 63,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _NavigationIcon(
                icon: isSelected ? item.selectedIcon ?? item.icon : item.icon,
                assetIcon: isSelected
                    ? item.selectedAssetIcon ?? item.assetIcon
                    : item.assetIcon,
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.brandSecondary
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationIcon extends StatelessWidget {
  const _NavigationIcon({this.icon, this.assetIcon});

  final IconData? icon;
  final String? assetIcon;

  @override
  Widget build(BuildContext context) {
    if (assetIcon != null) {
      return AppAssetIcon(
        assetIcon!,
        size: 35,
        color: AppColors.brandSecondary,
      );
    }

    return Icon(icon, size: 35, color: AppColors.brandSecondary);
  }
}
