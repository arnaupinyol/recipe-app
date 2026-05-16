import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';

class AppTextArea extends StatelessWidget {
  const AppTextArea({
    required this.label,
    super.key,
    this.controller,
    this.hintText,
    this.minLines = 4,
    this.maxLines = 6,
    this.enabled = true,
    this.validator,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final int minLines;
  final int maxLines;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        TextFormField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          enabled: enabled,
          validator: validator,
          onChanged: onChanged,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            hintText: hintText,
            contentPadding: const EdgeInsets.all(AppSpacing.lg),
          ),
        ),
      ],
    );
  }
}
