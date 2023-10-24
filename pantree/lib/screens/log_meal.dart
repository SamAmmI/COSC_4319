import 'package:flutter/material.dart';

class log_meal extends StatelessWidget {
  const log_meal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("log a meal"),
      centerTitle: true,
      ),
      body: const Center(
        child: Text("Here you can log a meal"),
      ),
    );
  }
}