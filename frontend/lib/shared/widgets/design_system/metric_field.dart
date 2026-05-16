import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import 'app_asset_icon.dart';

class MetricField extends StatelessWidget {
  const MetricField({
    required this.label,
    required this.value,
    super.key,
    this.unit,
    this.icon,
    this.assetIcon,
  });

  final String label;
  final String value;
  final String? unit;
  final IconData? icon;
  final String? assetIcon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (assetIcon != null || icon != null) ...[
            if (assetIcon != null)
              AppAssetIcon(assetIcon!, size: 20, color: AppColors.primary)
            else
              Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall,
                ),
                Text.rich(
                  TextSpan(
                    text: value,
                    children: [if (unit != null) TextSpan(text: ' $unit')],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
