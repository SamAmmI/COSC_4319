import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildAppBar extends StatelessWidget {
  const BuildAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 1,
      title: Text(
        title,
        style: Theme.of(context).appBarTheme.titleTextStyle ??
            const TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: true,
    );
  }
}
