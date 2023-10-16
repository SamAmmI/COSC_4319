import 'package:flutter/material.dart';
import 'package:testapp/models/food_item.dart'; //food item class

class AddFoodScreen extends StatelessWidget {
  final List<FoodItem> foodItems;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final Key? widgetKey;

  AddFoodScreen({required this.foodItems, this.widgetKey})
      : super(key: widgetKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Food Name'),
            ),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Calories'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var name = nameController.text;
                var calories = double.tryParse(caloriesController.text) ?? 0.0;
                if (name.isNotEmpty && calories > 0) {
                  foodItems.add(FoodItem(name: name, calories: calories));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Food Item'),
            ),
          ],
        ),
      ),
    );
  }
}
