import 'package:flutter/material.dart';

import 'home_recipe_models.dart';
import 'recipe_ingredients_page.dart';
import 'recipe_steps_page.dart';
import 'recipe_summary_page.dart';

class HomeRecipePager extends StatefulWidget {
  const HomeRecipePager({required this.recipe, super.key});

  final HomeRecipe recipe;

  @override
  State<HomeRecipePager> createState() => _HomeRecipePagerState();
}

class _HomeRecipePagerState extends State<HomeRecipePager> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stepPages = [
      for (final indexedStep in widget.recipe.steps.indexed)
        RecipeStepsPage(
          step: indexedStep.$2,
          totalSteps: widget.recipe.steps.length,
          onBackToStart: _backToStart,
          onPrevious: () => _animateToPage(indexedStep.$1 + 1),
          onNext: indexedStep.$1 == widget.recipe.steps.length - 1
              ? null
              : () => _animateToPage(indexedStep.$1 + 3),
        ),
    ];

    return PageView(
      controller: _controller,
      children: [
        RecipeSummaryPage(recipe: widget.recipe),
        RecipeIngredientsPage(recipe: widget.recipe),
        ...stepPages,
      ],
    );
  }

  void _backToStart() {
    _animateToPage(0);
  }

  void _animateToPage(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }
}
