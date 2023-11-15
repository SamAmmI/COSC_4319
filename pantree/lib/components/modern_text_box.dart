import 'package:flutter/material.dart';

class ModernTextBox extends StatefulWidget {
  final TextEditingController controller;
  final InputDecoration? decoration;
  final String? hintText;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final double width;
  final double height;
  final TextStyle textStyle;

  ModernTextBox({
    required this.controller,
    this.decoration,
    this.hintText,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.width = 300.0,
    this.height = 40.0,
    TextStyle? textStyle,
  }) : textStyle = textStyle ?? TextStyle(fontSize: 16); // Default TextStyle

  @override
  ModernTextBoxState createState() => ModernTextBoxState();
}

class ModernTextBoxState extends State<ModernTextBox> {
  bool isValid = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Color borderColor =
        theme.brightness == Brightness.light ? Colors.blue : Colors.orange;

    return Container(
      width: widget.width,
      height: widget.height,
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        onChanged: (text) {
          if (widget.onChanged != null) {
            widget.onChanged!(text);
          }
          setState(() {
            // INPUT VALIDATION SECTION
            isValid = true;
          });
        },
        style: widget.textStyle.copyWith(
          fontFamily: theme.textTheme.bodyLarge?.fontFamily,
          color: theme.textTheme.bodyLarge?.color,
        ),
        decoration: widget.decoration?.copyWith(
          hintText: widget.hintText,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: theme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
