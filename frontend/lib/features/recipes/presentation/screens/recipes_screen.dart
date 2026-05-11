import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/section_card.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = const [
      ('1', 'Paella de verdures'),
      ('2', 'Bowl de cigrons i tahina'),
      ('3', 'Torrades amb tomaca rostida'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receptes'),
        actions: [
          IconButton(
            onPressed: () => context.go(RoutePaths.profile),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Llista inicial',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aqui connectarem el GET /api/recipes i les primeres targetes derivades del disseny de Figma.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final recipe in recipes) ...[
            SectionCard(
              title: recipe.$2,
              description:
                  'Placeholder temporal per reservar la navegacio cap al detall.',
              onTap: () => context.go('/recipes/${recipe.$1}'),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
