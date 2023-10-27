import 'package:flutter/material.dart';

class browseFood extends StatelessWidget {
  const browseFood({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text('browse food'),
      centerTitle: true,
    ));
  }
}
