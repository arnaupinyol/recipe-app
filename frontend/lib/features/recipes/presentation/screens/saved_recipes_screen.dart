import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/assets/app_assets.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/design_system/bottom_navigation.dart';
import '../../../../shared/widgets/design_system/primary_button.dart';
import '../../application/home_recipes_provider.dart';
import '../../data/home_recipes_repository.dart';
import '../widgets/home_recipe_models.dart';
import '../widgets/recipe_card_compact.dart';

class SavedRecipesScreen extends ConsumerStatefulWidget {
  const SavedRecipesScreen({super.key});

  @override
  ConsumerState<SavedRecipesScreen> createState() => _SavedRecipesScreenState();
}

class _SavedRecipesScreenState extends ConsumerState<SavedRecipesScreen> {
  final Set<String> _updatingRecipeIds = {};

  @override
  Widget build(BuildContext context) {
    final savedRecipesState = ref.watch(savedRecipesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDefault,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 402),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      AppAssets.appIconSmall,
                      width: 50,
                      height: 50,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
                Positioned(
                  left: 27,
                  right: 28,
                  top: 82,
                  bottom: 77,
                  child: savedRecipesState.when(
                    data: (recipes) {
                      if (recipes.isEmpty) {
                        return const _SavedRecipesMessage(
                          message: 'Encara no tens receptes guardades.',
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];

                          return RecipeCardCompact(
                            recipe: recipe,
                            isBookmarkBusy: _updatingRecipeIds.contains(
                              recipe.id,
                            ),
                            onTap: () => _openRecipe(recipe),
                            onBookmarkPressed: () => _removeSavedRecipe(recipe),
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return _SavedRecipesError(
                        message: error.toString(),
                        onRetry: () {
                          ref.invalidate(savedRecipesProvider);
                        },
                      );
                    },
                    loading: () => const _SavedRecipesLoading(),
                  ),
                ),
                Positioned(
                  left: 27,
                  right: 28,
                  bottom: 0,
                  child: BottomNavigation(
                    selectedIndex: 3,
                    onDestinationSelected: _onDestinationSelected,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openRecipe(HomeRecipe recipe) {
    if (recipe.id.isEmpty) {
      return;
    }

    context.go('/recipes/${recipe.id}');
  }

  Future<void> _removeSavedRecipe(HomeRecipe recipe) async {
    final savedRecipeId = recipe.currentUserSavedRecipeId;
    if (savedRecipeId == null || _updatingRecipeIds.contains(recipe.id)) {
      return;
    }

    setState(() => _updatingRecipeIds.add(recipe.id));

    try {
      await ref.read(homeRecipesRepositoryProvider).unsaveRecipe(savedRecipeId);
      ref.invalidate(savedRecipesProvider);
      ref.invalidate(homeRecipesProvider(HomeFeed.forYou));
      ref.invalidate(homeRecipesProvider(HomeFeed.following));
    } on HomeRecipesException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) {
        setState(() => _updatingRecipeIds.remove(recipe.id));
      }
    }
  }

  void _onDestinationSelected(int index) {
    switch (index) {
      case 0:
        context.go(RoutePaths.recipes);
        break;
      case 3:
        break;
      case 4:
        context.go(RoutePaths.profile);
        break;
    }
  }
}

class _SavedRecipesLoading extends StatelessWidget {
  const _SavedRecipesLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.brandPrimary),
    );
  }
}

class _SavedRecipesError extends StatelessWidget {
  const _SavedRecipesError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SavedRecipesMessage(message: message),
          const SizedBox(height: 16),
          SizedBox(
            width: 180,
            child: PrimaryButton(label: 'Reintentar', onPressed: onRetry),
          ),
        ],
      ),
    );
  }
}

class _SavedRecipesMessage extends StatelessWidget {
  const _SavedRecipesMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.brandPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
