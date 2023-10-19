import 'package:flutter/material.dart';
import 'package:testapp/components/drawer.dart';
import 'package:testapp/screens/add_food_screen.dart'; // Import AddFoodScreen Class
import 'package:testapp/models/food_item.dart'; // Import the FoodItem class

class FoodInventoryScreen extends StatelessWidget {
  final List<FoodItem> foodItems;
  final Key? widgetKey; // Custom key parameter

  // Initialize the widgetKey parameter in the constructor
  const FoodInventoryScreen({Key? key, required this.foodItems, this.widgetKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Inventory'),
      ),
      drawer: MyDrawer(
        onSignOutTap: () {  },

      ),
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          var foodItem = foodItems[index];
          return ListTile(
            title: Text(foodItem.name),
            subtitle: Text('${foodItem.calories} calories'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddFoodScreen(foodItems: foodItems)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
