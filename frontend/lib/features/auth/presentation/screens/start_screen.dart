import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/design_system/primary_button.dart';
import '../widgets/auth_canvas.dart';
import '../widgets/auth_logo_mark.dart';
import '../widgets/auth_text_link.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AuthCanvas(
      children: [
        const AuthLogoMark(),
        Positioned(
          left: 0,
          top: 379,
          width: AuthCanvas.width,
          child: Text(
            'Hola!',
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontSize: 28,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Positioned(
          left: 49,
          top: 436,
          width: 304,
          child: Text(
            'Benvingut a l app de receptes, on trobaras un cataleg dinamic per a tu.',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 14,
              height: 1.2,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Positioned(
          left: 90,
          top: 534,
          width: 221,
          child: PrimaryButton(
            label: 'Login',
            onPressed: () => context.go(RoutePaths.login),
          ),
        ),
        Positioned(
          left: 90,
          top: 612,
          width: 221,
          child: PrimaryButton(
            label: 'Sign up',
            onPressed: () => context.go(RoutePaths.register),
          ),
        ),
        Positioned(
          left: 122,
          top: 690,
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
      ],
    );
  }
}
