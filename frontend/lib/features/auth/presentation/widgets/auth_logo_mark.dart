import 'package:flutter/material.dart';

import '../../../../shared/widgets/design_system/app_logo.dart';

class AuthLogoMark extends StatelessWidget {
  const AuthLogoMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 101,
      top: 160,
      width: 200,
      height: 190,
      child: AppLogo(size: 200, height: 190, showText: false),
    );
  }
}
