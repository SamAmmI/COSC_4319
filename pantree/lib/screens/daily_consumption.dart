import 'package:flutter/material.dart';

class DailyConsumptionScreen extends StatelessWidget {
  const DailyConsumptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Consumption",),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("daily consumption details here"),
      )
    );
  }
}