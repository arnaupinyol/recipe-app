import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/section_card.dart';
import '../../../auth/application/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Perfil i sessio',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aquesta pantalla acabara llegint /api/auth/me i mostrant dades del compte.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionCard(
            title: 'Dades previstes',
            description:
                'Username, email, bio, idioma, al lergies i preferencies de notificacions.',
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.tonal(
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();

              if (!context.mounted) {
                return;
              }

              context.go(RoutePaths.login);
            },
            child: const Text('Tancar sessio temporal'),
          ),
        ],
      ),
    );
  }
}
