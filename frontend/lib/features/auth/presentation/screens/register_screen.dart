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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final username = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Introdueix nom, email i contrassenya.');
      return;
    }

    try {
      await ref
          .read(authControllerProvider.notifier)
          .signUp(username: username, email: email, password: password);

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
          left: 105,
          top: 360,
          child: Text(
            'Sign up',
            style: textTheme.headlineMedium?.copyWith(
              fontSize: 28,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Positioned(
          left: 34,
          top: 420,
          width: 335,
          child: AppTextField(
            label: 'Nom',
            controller: _nameController,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
          ),
        ),
        Positioned(
          left: 34,
          top: 517,
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
          top: 614,
          width: 335,
          child: AppTextField(
            label: 'Contrassenya',
            controller: _passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
          ),
        ),
        Positioned(
          left: 91,
          top: 723,
          width: 221,
          child: PrimaryButton(
            label: 'Crear compte',
            isLoading: authState.isLoading,
            onPressed: _submit,
          ),
        ),
      ],
    );
  }
}
