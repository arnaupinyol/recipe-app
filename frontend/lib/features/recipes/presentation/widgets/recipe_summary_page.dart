import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/assets/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/design_system/app_asset_icon.dart';
import '../../application/home_recipes_provider.dart';
import '../../data/home_recipes_repository.dart';
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
                    _DifficultyStars(difficulty: recipe.difficulty),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 28,
              height: 1.06,
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

class _DifficultyStars extends StatelessWidget {
  const _DifficultyStars({required this.difficulty});

  final int difficulty;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < 5; index++)
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: AppAssetIcon(
              index < difficulty
                  ? AppAssets.recipeStarFullIcon
                  : AppAssets.recipeStarEmptyIcon,
              size: 32,
              color: AppColors.brandPrimary,
            ),
          ),
      ],
    );
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

class _RecipeActions extends ConsumerStatefulWidget {
  const _RecipeActions({required this.recipe});

  final HomeRecipe recipe;

  @override
  ConsumerState<_RecipeActions> createState() => _RecipeActionsState();
}

class _RecipeActionsState extends ConsumerState<_RecipeActions> {
  late bool _isLiked;
  late bool _isBookmarked;
  late int _likesCount;
  late int _savesCount;
  int? _likeId;
  int? _savedRecipeId;
  var _isUpdatingLike = false;
  var _isUpdatingSave = false;

  @override
  void initState() {
    super.initState();
    _syncFromRecipe();
  }

  @override
  void didUpdateWidget(covariant _RecipeActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.recipe != widget.recipe) {
      _syncFromRecipe();
    }
  }

  void _syncFromRecipe() {
    _isLiked = widget.recipe.isLiked;
    _isBookmarked = widget.recipe.isBookmarked;
    _likesCount = widget.recipe.likesCount;
    _savesCount = widget.recipe.savesCount;
    _likeId = widget.recipe.currentUserLikeId;
    _savedRecipeId = widget.recipe.currentUserSavedRecipeId;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          _ActionCounterButton(
            semanticLabel: _isLiked ? 'Treure like' : 'Donar like',
            asset: _isLiked
                ? AppAssets.recipeHeartFullIcon
                : AppAssets.recipeHeartEmptyIcon,
            count: _likesCount,
            isBusy: _isUpdatingLike,
            onPressed: _toggleLike,
          ),
          const SizedBox(height: 8),
          _ActionCounterButton(
            semanticLabel: _isBookmarked ? 'Treure de guardats' : 'Guardar',
            asset: _isBookmarked
                ? AppAssets.recipeBookmarkFullIcon
                : AppAssets.recipeBookmarkEmptyIcon,
            count: _savesCount,
            isBusy: _isUpdatingSave,
            onPressed: _toggleSave,
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

  Future<void> _toggleLike() async {
    if (_isUpdatingLike) {
      return;
    }

    setState(() => _isUpdatingLike = true);
    final repository = ref.read(homeRecipesRepositoryProvider);

    try {
      if (_isLiked) {
        final likeId = _likeId;
        if (likeId == null) {
          return;
        }

        await repository.unlikeRecipe(likeId);
        if (!mounted) {
          return;
        }

        setState(() {
          _isLiked = false;
          _likeId = null;
          _likesCount = _likesCount > 0 ? _likesCount - 1 : 0;
        });
      } else {
        final likeId = await repository.likeRecipe(widget.recipe.id);
        if (!mounted) {
          return;
        }

        setState(() {
          _isLiked = true;
          _likeId = likeId;
          _likesCount += 1;
        });
      }

      _refreshHomeFeeds();
    } on HomeRecipesException catch (error) {
      _showActionError(error.message);
    } finally {
      if (mounted) {
        setState(() => _isUpdatingLike = false);
      }
    }
  }

  Future<void> _toggleSave() async {
    if (_isUpdatingSave) {
      return;
    }

    setState(() => _isUpdatingSave = true);
    final repository = ref.read(homeRecipesRepositoryProvider);

    try {
      if (_isBookmarked) {
        final savedRecipeId = _savedRecipeId;
        if (savedRecipeId == null) {
          return;
        }

        await repository.unsaveRecipe(savedRecipeId);
        if (!mounted) {
          return;
        }

        setState(() {
          _isBookmarked = false;
          _savedRecipeId = null;
          _savesCount = _savesCount > 0 ? _savesCount - 1 : 0;
        });
      } else {
        final savedRecipeId = await repository.saveRecipe(widget.recipe.id);
        if (!mounted) {
          return;
        }

        setState(() {
          _isBookmarked = true;
          _savedRecipeId = savedRecipeId;
          _savesCount += 1;
        });
      }

      _refreshHomeFeeds();
    } on HomeRecipesException catch (error) {
      _showActionError(error.message);
    } finally {
      if (mounted) {
        setState(() => _isUpdatingSave = false);
      }
    }
  }

  void _refreshHomeFeeds() {
    ref.invalidate(homeRecipesProvider(HomeFeed.forYou));
    ref.invalidate(homeRecipesProvider(HomeFeed.following));
    ref.invalidate(savedRecipesProvider);
  }

  void _showActionError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ActionCounterButton extends StatelessWidget {
  const _ActionCounterButton({
    required this.semanticLabel,
    required this.asset,
    required this.count,
    required this.isBusy,
    required this.onPressed,
  });

  final String semanticLabel;
  final String asset;
  final int count;
  final bool isBusy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkResponse(
        onTap: isBusy ? null : onPressed,
        radius: 28,
        child: Opacity(
          opacity: isBusy ? 0.55 : 1,
          child: SizedBox(
            width: 52,
            child: Column(
              children: [
                AppAssetIcon(asset, size: 44, color: AppColors.brandPrimary),
                const SizedBox(height: 2),
                Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.brandPrimary,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
