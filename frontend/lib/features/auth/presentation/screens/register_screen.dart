import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/section_card.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Registre',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Pantalla placeholder per reservar el flux de creacio de compte.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionCard(
            title: 'Camp base previst',
            description:
                'Username, email, password, confirmacio i idioma preferit.',
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => context.go(RoutePaths.login),
            child: const Text('Tornar al login'),
          ),
        ],
      ),
    );
  }
}
