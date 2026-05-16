import 'package:flutter/material.dart' hide SearchBar;

import '../../../app/assets/app_assets.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import 'app_asset_icon.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    this.controller,
    this.hintText = 'Cerca',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const AppAssetIcon(
          AppAssets.bottomNavigationSearchIcon,
          size: 22,
        ),
        suffixIcon: onClear == null
            ? null
            : IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close),
                tooltip: 'Neteja',
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.xxl),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.xxl),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
