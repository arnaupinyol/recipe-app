import 'package:flutter/material.dart';

import '../../../../app/assets/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/design_system/app_asset_icon.dart';

class HomeFilterBar extends StatelessWidget {
  const HomeFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 27),
        children: const [_AddFilterButton()],
      ),
    );
  }
}

class _AddFilterButton extends StatelessWidget {
  const _AddFilterButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Afegir filtre',
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.brandPrimary),
          shape: BoxShape.circle,
        ),
        child: const AppAssetIcon(
          AppAssets.filterAddIcon,
          size: 18,
          color: AppColors.brandPrimary,
        ),
      ),
    );
  }
}
