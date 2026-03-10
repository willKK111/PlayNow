import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final bool obscure;
  final TextEditingController? controller;

  const InputField(
      this.icon,
      this.label,
      this.hint, {
        this.obscure = false,
        this.controller,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: colorScheme.primary),
        labelText: label,
        labelStyle: TextStyle(color: colorScheme.primary),
        hintText: hint,
        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
