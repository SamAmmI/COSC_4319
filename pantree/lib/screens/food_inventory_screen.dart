import 'package:flutter/material.dart';
import 'package:pantree/components/drawer.dart';
import 'package:pantree/screens/add_food_screen.dart'; // Import AddFoodScreen Class
import 'package:pantree/models/food_item.dart'; // Import the FoodItem class

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
        title: Text('Food Inventory',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      drawer: MyDrawer(
        onSignOutTap: (){},
        onFoodInventoryTap: (){},
        onNutritionTap: (){},
        onSettingsTap: (){},

      ),
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          var foodItem = foodItems[index];
          return ListTile(
            title: Text(foodItem.getNutrientDetails("name")),
            subtitle: Text('${foodItem.getNutrientDetails("calories")} calories'),
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
