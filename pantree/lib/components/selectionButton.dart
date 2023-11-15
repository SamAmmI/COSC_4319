import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry iconPadding;
  final Color? color;
  final TextStyle textStyle;
  final double elevation;
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  final ThemeData? theme; // Add a ThemeData parameter

  SelectionButton({
    required this.onPressed,
    required this.text,
    this.width = 120,
    this.height,
    this.padding = EdgeInsets.zero,
    this.iconPadding = EdgeInsets.zero,
    this.color,
    required this.textStyle,
    this.elevation = 3,
    this.borderSide = const BorderSide(
      color: Colors.transparent,
      width: 1,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData buttonTheme = theme ?? Theme.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: color ?? buttonTheme.primaryColor,
          textStyle: textStyle,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: borderSide,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: buttonTheme.textTheme.bodyLarge?.fontFamily,
            color: buttonTheme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
