import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/design_system/app_text_field.dart';
import '../../../../shared/widgets/design_system/primary_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.onRegisterPressed,
    super.key,
    this.isSubmitting = false,
    this.onForgotPasswordPressed,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Future<void> Function() onSubmit;
  final VoidCallback onRegisterPressed;
  final bool isSubmitting;
  final VoidCallback? onForgotPasswordPressed;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  Future<void> _handleSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || widget.isSubmitting) {
      return;
    }

    await widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'Email',
              hintText: 'nom@exemple.com',
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              prefixIcon: const Icon(Icons.mail_outline),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) {
                  return 'Introdueix el teu email';
                }
                if (!email.contains('@')) {
                  return 'Introdueix un email valid';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Contrasenya',
              hintText: 'La teva contrasenya',
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                tooltip: _obscurePassword
                    ? 'Mostra contrasenya'
                    : 'Amaga contrasenya',
              ),
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return 'Introdueix la contrasenya';
                }
                return null;
              },
              onSubmitted: (_) => _handleSubmit(),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (widget.onForgotPasswordPressed != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.isSubmitting
                      ? null
                      : widget.onForgotPasswordPressed,
                  child: Text(
                    'Has oblidat la contrasenya?',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Inicia sessio',
              icon: Icons.arrow_forward,
              isLoading: widget.isSubmitting,
              onPressed: _handleSubmit,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    'Encara no tens compte?',
                    style: textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: widget.isSubmitting
                      ? null
                      : widget.onRegisterPressed,
                  child: const Text('Registra-t'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
