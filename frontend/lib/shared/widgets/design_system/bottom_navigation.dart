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
        label: 'Inici',
      ),
      BottomNavigationItem(
        assetIcon: AppAssets.bottomNavigationSearchIcon,
        label: 'Cerca',
      ),
      BottomNavigationItem(
        assetIcon: AppAssets.bottomNavigationBookmarkIcon,
        label: 'Guardades',
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
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.background,
      destinations: [
        for (final destination in destinations)
          NavigationDestination(
            icon: _NavigationIcon(
              icon: destination.icon,
              assetIcon: destination.assetIcon,
            ),
            selectedIcon: _NavigationIcon(
              icon: destination.selectedIcon ?? destination.icon,
              assetIcon: destination.selectedAssetIcon ?? destination.assetIcon,
            ),
            label: destination.label,
          ),
      ],
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

class _NavigationIcon extends StatelessWidget {
  const _NavigationIcon({this.icon, this.assetIcon});

  final IconData? icon;
  final String? assetIcon;

  @override
  Widget build(BuildContext context) {
    if (assetIcon != null) {
      return AppAssetIcon(assetIcon!, size: 24);
    }

    return Icon(icon);
  }
}
