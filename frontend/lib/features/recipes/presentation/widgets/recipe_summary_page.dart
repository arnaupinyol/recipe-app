import 'package:flutter/material.dart';

import '../../../../app/assets/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/design_system/app_asset_icon.dart';
import 'home_recipe_models.dart';

class RecipeSummaryPage extends StatelessWidget {
  const RecipeSummaryPage({required this.recipe, super.key});

  final HomeRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RecipeTitle(recipe: recipe),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _RecipeImage(
                  asset: recipe.imageAsset,
                  imageUrl: recipe.imageUrl,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_forward,
                color: AppColors.brandPrimary,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RatingStars(rating: recipe.rating),
                    const SizedBox(height: 12),
                    _InfoMetric(
                      icon: AppAssets.recipeClockIcon,
                      label: recipe.duration,
                      iconSize: 30,
                    ),
                    const SizedBox(height: 12),
                    _InfoMetric(
                      icon: AppAssets.recipeGroupsIcon,
                      label: recipe.servings,
                      iconSize: 27,
                    ),
                  ],
                ),
              ),
              _RecipeActions(recipe: recipe),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecipeTitle extends StatelessWidget {
  const _RecipeTitle({required this.recipe});

  final HomeRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppAssetIcon(
          recipe.authorAvatarAsset,
          size: 36,
          color: AppColors.textPrimary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            recipe.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 36,
              height: 1,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({required this.asset, this.imageUrl});

  final String asset;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 326 / 347,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: imageUrl == null
            ? _AssetRecipeImage(asset: asset)
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return _AssetRecipeImage(asset: asset);
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

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < 5; index++)
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: AppAssetIcon(
              _assetFor(index),
              size: 32,
              color: AppColors.brandPrimary,
            ),
          ),
      ],
    );
  }

  String _assetFor(int index) {
    final value = index + 1;
    if (rating >= value) {
      return AppAssets.recipeStarFullIcon;
    }
    if (rating > index) {
      return AppAssets.recipeHalfStarFullIcon;
    }
    return AppAssets.recipeStarEmptyIcon;
  }
}

class _InfoMetric extends StatelessWidget {
  const _InfoMetric({
    required this.icon,
    required this.label,
    required this.iconSize,
  });

  final String icon;
  final String label;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppAssetIcon(icon, size: iconSize, color: AppColors.brandPrimary),
        const SizedBox(width: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.brandPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _RecipeActions extends StatelessWidget {
  const _RecipeActions({required this.recipe});

  final HomeRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          AppAssetIcon(
            recipe.isLiked
                ? AppAssets.recipeHeartFullIcon
                : AppAssets.recipeHeartEmptyIcon,
            size: 48,
            color: AppColors.brandPrimary,
          ),
          const SizedBox(height: 10),
          AppAssetIcon(
            recipe.isBookmarked
                ? AppAssets.recipeBookmarkFullIcon
                : AppAssets.recipeBookmarkEmptyIcon,
            size: 48,
            color: AppColors.brandPrimary,
          ),
          const SizedBox(height: 10),
          const AppAssetIcon(
            AppAssets.recipeCommentIcon,
            size: 34,
            color: AppColors.brandPrimary,
          ),
        ],
      ),
    );
  }
}
