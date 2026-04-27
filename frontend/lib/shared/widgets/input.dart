import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class ShadcnInput extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;

  const ShadcnInput({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: theme.textTheme.bodyLarge, 
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium, 
        filled: true,
        fillColor: theme.colorScheme.surface, 
        contentPadding: AppConstants.inputPadding,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall), 
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
