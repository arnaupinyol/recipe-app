import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/section_card.dart';
import '../../application/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Recipe App',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Base inicial del frontend. El seguent pas sera connectar aquesta pantalla amb l API d autenticacio.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const SectionCard(
                          title: 'Que hi farem aqui',
                          description:
                              'Login, registre, persistencia del token i redireccio segons la sessio.',
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        FilledButton(
                          onPressed: () async {
                            await ref
                                .read(authControllerProvider.notifier)
                                .signInPlaceholder();

                            if (!context.mounted) {
                              return;
                            }

                            context.go(RoutePaths.recipes);
                          },
                          child: const Text('Entrar amb flow temporal'),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        OutlinedButton(
                          onPressed: () => context.go(RoutePaths.register),
                          child: const Text('Anar a registre'),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Quan passem Figma a codi, aquesta sera la primera pantalla real a substituir.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
