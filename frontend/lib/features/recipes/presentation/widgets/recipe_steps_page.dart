import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/design_system/primary_button.dart';
import 'home_recipe_models.dart';

class RecipeStepsPage extends StatelessWidget {
  const RecipeStepsPage({
    required this.step,
    required this.totalSteps,
    required this.onBackToStart,
    super.key,
    this.onPrevious,
    this.onNext,
  });

  final HomeRecipeStep step;
  final int totalSteps;
  final VoidCallback onBackToStart;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 66, 5, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34),
            child: Text(
              'Instruccions:',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.brandPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34),
            child: Text(
              _stepTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.brandSecondary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 96),
                  child: _StepArrow(
                    icon: Icons.arrow_back,
                    onPressed: onPrevious,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      step.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.brandSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 96),
                  child: _StepArrow(
                    icon: Icons.arrow_forward,
                    onPressed: onNext,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: 221,
              child: PrimaryButton(
                label: 'Tornar al principi',
                fullWidth: true,
                onPressed: onBackToStart,
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  String get _stepTitle {
    if (step.title.isEmpty) {
      return totalSteps == 1
          ? 'Pas ${step.orderNumber}'
          : 'Pas ${step.orderNumber} de $totalSteps';
    }

    return '${step.orderNumber}. ${step.title}';
  }
}

class _StepArrow extends StatelessWidget {
  const _StepArrow({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 28, height: 28),
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: onPressed == null
            ? AppColors.brandPrimary.withValues(alpha: 0.25)
            : AppColors.brandPrimary,
        size: 28,
      ),
    );
  }
}
