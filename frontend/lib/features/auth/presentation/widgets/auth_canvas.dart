import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class AuthCanvas extends StatelessWidget {
  const AuthCanvas({required this.children, super.key});

  static const width = 402.0;
  static const height = 852.0;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Stack(clipBehavior: Clip.none, children: children),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
