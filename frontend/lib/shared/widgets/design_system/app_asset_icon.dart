import 'package:flutter/material.dart';

class AppAssetIcon extends StatelessWidget {
  const AppAssetIcon(
    this.assetPath, {
    super.key,
    this.size = 24,
    this.color,
    this.semanticLabel,
  });

  final String assetPath;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return ImageIcon(
      AssetImage(assetPath),
      size: size,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}
