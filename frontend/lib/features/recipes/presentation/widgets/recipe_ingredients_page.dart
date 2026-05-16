import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import 'home_recipe_models.dart';

class RecipeIngredientsPage extends StatelessWidget {
  const RecipeIngredientsPage({required this.recipe, super.key});

  final HomeRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(52, 54, 52, 28),
      physics: const ClampingScrollPhysics(),
      children: [
        const _SectionTitle('Ingredients'),
        const SizedBox(height: 18),
        if (recipe.ingredients.isEmpty)
          const _EmptySectionMessage('Sense ingredients indicats.')
        else
          for (final ingredient in recipe.ingredients) ...[
            _IngredientRow(
              title: ingredient.name,
              subtitle: ingredient.amount,
              note: ingredient.note,
              imageAsset: ingredient.imageAsset,
              imageUrl: ingredient.imageUrl,
            ),
            const SizedBox(height: 14),
          ],
        const SizedBox(height: 20),
        const _SectionTitle('Estris'),
        const SizedBox(height: 18),
        if (recipe.utensils.isEmpty)
          const _EmptySectionMessage('Sense estris indicats.')
        else
          for (final utensil in recipe.utensils) ...[
            _IngredientRow(
              title: utensil.name,
              subtitle: '1 unitat',
              note: 'Estri de cuina',
              imageAsset: utensil.imageAsset,
              imageUrl: utensil.imageUrl,
            ),
            const SizedBox(height: 14),
          ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: AppColors.brandPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _EmptySectionMessage extends StatelessWidget {
  const _EmptySectionMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: AppColors.brandSecondary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.title,
    required this.subtitle,
    required this.note,
    required this.imageAsset,
    this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String note;
  final String imageAsset;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 82,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl == null
                ? _RowAssetImage(asset: imageAsset)
                : Image.network(
                    imageUrl!,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return _RowAssetImage(asset: imageAsset);
                    },
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      fontSize: 15,
                      height: 1.05,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.brandPrimary,
                      fontSize: 11,
                      height: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 17,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.brandPrimary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.brandSecondary,
                        fontSize: 9,
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

class _RowAssetImage extends StatelessWidget {
  const _RowAssetImage({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: 75,
      height: 75,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }
}
