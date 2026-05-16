import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import 'home_recipe_models.dart';

class RecipeIngredientsPage extends StatelessWidget {
  const RecipeIngredientsPage({required this.recipe, super.key});

  final HomeRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(71, 99, 71, 24),
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return _IngredientRow(ingredient: recipe.ingredients[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 13),
      itemCount: recipe.ingredients.length,
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.ingredient});

  final HomeRecipeIngredient ingredient;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 63,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ingredient.imageUrl == null
                ? _IngredientAssetImage(asset: ingredient.imageAsset)
                : Image.network(
                    ingredient.imageUrl!,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return _IngredientAssetImage(
                        asset: ingredient.imageAsset,
                      );
                    },
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      height: 1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ingredient.amount,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.brandPrimary,
                      height: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 14,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.brandPrimary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ingredient.note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.brandSecondary,
                        fontSize: 8,
                        height: 1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientAssetImage extends StatelessWidget {
  const _IngredientAssetImage({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: 52,
      height: 52,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }
}
