import 'package:flutter/material.dart';

import '../../../app/assets/app_assets.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 96,
    this.height,
    this.showText = true,
    this.alignment = MainAxisAlignment.center,
  });

  final double size;
  final double? height;
  final bool showText;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      AppAssets.appIconLarge,
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );

    if (!showText) {
      return logo;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: [
        logo,
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            'Recipe App',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
