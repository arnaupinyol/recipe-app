import 'package:flutter/material.dart';

import '../../../../app/assets/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/design_system/app_asset_icon.dart';

class HomeFilterBar extends StatelessWidget {
  const HomeFilterBar({required this.filters, super.key});

  final List<String> filters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 27),
        itemBuilder: (context, index) {
          if (index == filters.length) {
            return const _AddFilterButton();
          }

          return _FilterChip(label: filters[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: filters.length + 1,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.brandPrimary),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.brandPrimary,
          fontWeight: FontWeight.w700,
        ),
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
