import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/design_system/bottom_navigation.dart';
import '../../../../shared/widgets/design_system/primary_button.dart';
import '../../application/home_recipes_provider.dart';
import '../widgets/home_filter_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/home_recipe_pager.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  var _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final feed = _selectedTab == 0 ? HomeFeed.forYou : HomeFeed.following;
    final recipesState = ref.watch(homeRecipesProvider(feed));

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
                  left: 27,
                  right: 28,
                  top: 8,
                  child: HomeHeader(
                    selectedTab: _selectedTab,
                    onTabSelected: (value) {
                      setState(() => _selectedTab = value);
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 118,
                  child: const HomeFilterBar(),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 154,
                  bottom: 77,
                  child: recipesState.when(
                    data: (recipes) {
                      if (recipes.isEmpty) {
                        return _EmptyHomeMessage(feed: feed);
                      }

                      return PageView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          return HomeRecipePager(recipe: recipes[index]);
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return _HomeError(
                        message: error.toString(),
                        onRetry: () {
                          ref.invalidate(homeRecipesProvider(feed));
                        },
                      );
                    },
                    loading: () => const _HomeLoading(),
                  ),
                ),
                Positioned(
                  left: 27,
                  right: 28,
                  bottom: 0,
                  child: BottomNavigation(
                    selectedIndex: 0,
                    onDestinationSelected: (index) {
                      if (index == 4) {
                        context.go(RoutePaths.profile);
                      }
                    },
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

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.brandPrimary),
    );
  }
}

class _EmptyHomeMessage extends StatelessWidget {
  const _EmptyHomeMessage({required this.feed});

  final HomeFeed feed;

  @override
  Widget build(BuildContext context) {
    final message = feed == HomeFeed.following
        ? 'Encara no hi ha receptes de persones que segueixes.'
        : 'Encara no hi ha receptes disponibles.';

    return _HomeMessage(message: message);
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _HomeMessage(message: message),
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

class _HomeMessage extends StatelessWidget {
  const _HomeMessage({required this.message});

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
