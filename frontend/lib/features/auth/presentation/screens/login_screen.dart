import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/design_system/app_text_field.dart';
import '../../../../shared/widgets/design_system/primary_button.dart';
import '../../application/auth_controller.dart';
import '../../data/auth_exception.dart';
import '../widgets/auth_canvas.dart';
import '../widgets/auth_logo_mark.dart';
import '../widgets/auth_text_link.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Introdueix email i contrassenya.');
      return;
    }

    try {
      await ref
          .read(authControllerProvider.notifier)
          .signIn(email: email, password: password);
      if (!mounted) {
        return;
      }

      context.go(RoutePaths.recipes);
    } on AuthException catch (error) {
      _showError(error.message);
    }
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authControllerProvider);

    return AuthCanvas(
      children: [
        const AuthLogoMark(),
        Positioned(
          left: 0,
          top: 379,
          width: AuthCanvas.width,
          child: Text(
            'Login',
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontFamily: 'Inter',
              fontSize: 28,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Positioned(
          left: 34,
          top: 440,
          width: 335,
          child: AppTextField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
          ),
        ),
        Positioned(
          left: 34,
          top: 537,
          width: 335,
          child: AppTextField(
            label: 'Contrassenya',
            controller: _passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onSubmitted: (_) => _submit(),
          ),
        ),
        Positioned(
          left: 122,
          top: 627,
          width: 158,
          child: AuthTextLink(
            label: 'Crea un compte',
            onPressed: () => context.go(RoutePaths.register),
          ),
        ),
        Positioned(
          left: 122,
          top: 669,
          width: 158,
          child: AuthTextLink(
            label: 'No recordo la meva contrassenya',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Recuperacio de contrasenya pendent.'),
                ),
              );
            },
          ),
        ),
        Positioned(
          left: 91,
          top: 723,
          width: 221,
          child: PrimaryButton(
            label: 'Sign in',
            isLoading: authState.isLoading,
            onPressed: _submit,
          ),
        ),
      ],
    );
  }
}
