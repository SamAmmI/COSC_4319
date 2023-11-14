import 'package:flutter/material.dart';
import '../components/drawer.dart';

class nutrition_screen extends StatefulWidget {
  const nutrition_screen({super.key});

  @override
  State<nutrition_screen> createState() => _nutrition_screenState();
}

class _nutrition_screenState extends State<nutrition_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrition"),
      ),
      drawer: MyDrawer(
        onSignOutTap: (){},
        onFoodInventoryTap: (){},
        onNutritionTap: (){},
      ),
    );
  }
}
