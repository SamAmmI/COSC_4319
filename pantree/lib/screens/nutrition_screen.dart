import 'package:flutter/material.dart';
import 'package:pantree/components/drawer.dart';

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
        title: Text("Nutrition",
        style: TextStyle(color: Theme.of(context).colorScheme.primary)
        ),
      ),
      drawer: MyDrawer(
        onSignOutTap: (){},
        onFoodInventoryTap: (){},
        onNutritionTap: (){},
        onSettingsTap: (){},
      ),
    );
  }
}
