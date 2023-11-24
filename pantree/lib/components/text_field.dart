import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextStyle? style;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      style: theme.textTheme.bodyLarge,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary)),
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(color: colorScheme.primary)),
        fillColor: Colors.transparent,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: colorScheme.primary),
      ),
    );
  }
}
