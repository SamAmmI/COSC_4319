import 'package:flutter/material.dart';
import 'package:pantree/screens/search_food.dart';
import 'package:pantree/screens/food_inventory_screen.dart';

class MealLogScreen extends StatefulWidget {
  const MealLogScreen({Key? key}) : super(key: key);

  @override
  _MealLogScreenState createState() => _MealLogScreenState();
}

class _MealLogScreenState extends State<MealLogScreen> {
  List<String> mealItems = [];

  void _addFoodItemToMeal(String foodItem) {
    setState(() {
      mealItems.add(foodItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Meal"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchFood(
                    userId: '',
                  ),
                ),
              );
            },
            child: const Text("Search Food Item"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodInventoryScreen(
                    foodItems: const [],
                    onFoodItemSelected: (String foodItem) {},
                  ),
                ),
              );
            },
            child: const Text("Import from Food Inventory"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mealItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(mealItems[index]),
                  // Add more details about the food item if needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
