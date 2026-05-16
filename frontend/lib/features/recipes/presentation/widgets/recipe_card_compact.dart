import 'package:flutter/material.dart';

import '../../../../app/assets/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/design_system/app_asset_icon.dart';
import 'home_recipe_models.dart';

class RecipeCardCompact extends StatelessWidget {
  const RecipeCardCompact({
    required this.recipe,
    super.key,
    this.showSeparator = true,
    this.isBookmarkBusy = false,
    this.onTap,
    this.onBookmarkPressed,
  });

  final HomeRecipe recipe;
  final bool showSeparator;
  final bool isBookmarkBusy;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: recipe.title,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.brandSecondary.withValues(alpha: 0.12),
        highlightColor: AppColors.brandSecondary.withValues(alpha: 0.08),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 146),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 16, 8, 26),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CompactRecipeImage(recipe: recipe),
                    const SizedBox(width: 10),
                    Expanded(child: _CompactRecipeInfo(recipe: recipe)),
                    const SizedBox(width: 8),
                    _BookmarkButton(
                      isBusy: isBookmarkBusy,
                      onPressed: onBookmarkPressed,
                    ),
                  ],
                ),
              ),
              if (showSeparator)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.brandSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactRecipeImage extends StatelessWidget {
  const _CompactRecipeImage({required this.recipe});

  final HomeRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox.square(
        dimension: 103,
        child: recipe.imageUrl == null
            ? _AssetRecipeImage(asset: recipe.imageAsset)
            : Image.network(
                recipe.imageUrl!,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return _AssetRecipeImage(asset: recipe.imageAsset);
                },
              ),
      ),
    );
  }
}

class _AssetRecipeImage extends StatelessWidget {
  const _AssetRecipeImage({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }
}

class _CompactRecipeInfo extends StatelessWidget {
  const _CompactRecipeInfo({required this.recipe});

  final HomeRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 103),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 21,
              height: 1.05,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          _CompactStars(difficulty: recipe.difficulty),
          const SizedBox(height: 4),
          _CompactMetric(
            icon: AppAssets.recipeClockIcon,
            label: recipe.duration,
            iconSize: 25,
          ),
          const SizedBox(height: 2),
          _CompactMetric(
            icon: AppAssets.recipeGroupsIcon,
            label: recipe.servings,
            iconSize: 21,
          ),
        ],
      ),
    );
  }
}

class _CompactStars extends StatelessWidget {
  const _CompactStars({required this.difficulty});

  final int difficulty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: Row(
        children: [
          for (var index = 0; index < 5; index++)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: AppAssetIcon(
                index < difficulty
                    ? AppAssets.recipeStarFullIcon
                    : AppAssets.recipeStarEmptyIcon,
                size: 22,
                color: AppColors.brandPrimary,
              ),
            ),
        ],
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.icon,
    required this.label,
    required this.iconSize,
  });

  final String icon;
  final String label;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23,
      child: Row(
        children: [
          SizedBox(
            width: 25,
            child: AppAssetIcon(
              icon,
              size: iconSize,
              color: AppColors.brandPrimary,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                height: 1,
                color: AppColors.brandPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  const _BookmarkButton({required this.isBusy, this.onPressed});

  final bool isBusy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onPressed != null,
      label: 'Treure de guardats',
      child: InkResponse(
        onTap: isBusy ? null : onPressed,
        radius: 28,
        child: Opacity(
          opacity: isBusy ? 0.55 : 1,
          child: const SizedBox(
            width: 43,
            height: 103,
            child: Center(
              child: AppAssetIcon(
                AppAssets.recipeBookmarkFullIcon,
                size: 39,
                color: AppColors.brandPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
