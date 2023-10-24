import 'package:flutter/material.dart';

class nutritional_preferences extends StatelessWidget {
  const nutritional_preferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrional preferences"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Here you can adjust your nutritional preferences"),
      ),
    );
  }
}