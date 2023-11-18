import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/components/drawer.dart';
import 'package:pantree/models/food_item.dart';
import 'package:pantree/screens/search_food.dart';
import 'package:pantree/components/food_image.dart';
import 'package:pantree/services/food_manager.dart';

class FoodInventoryScreen extends StatefulWidget {
  final List<FoodItem> foodItems;
  final void Function(String foodItem) onFoodItemSelected; // Callback function

  const FoodInventoryScreen({
    Key? key,
    required this.foodItems,
    required this.onFoodItemSelected, // Required callback function
  }) : super(key: key);

  @override
  _FoodInventoryScreenState createState() => _FoodInventoryScreenState();
}

class _FoodInventoryScreenState extends State<FoodInventoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  late String _userId;
  List<FoodItem> _userFoodItems = [];

  // Initialize FoodManagement class
  late FoodManagement _foodManagement;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    _user = _auth.currentUser!;
    _userId = _user.uid;

    // Initialize FoodManagement with user ID
    _foodManagement = FoodManagement(_userId);

    // Fetch user's food items and update the state
    _getUserFoodItems();
  }

  Future<void> _getUserFoodItems() async {
    List<FoodItem> userFoodItems = await _foodManagement.getUserFoodItems();

    setState(() {
      _userFoodItems = userFoodItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Inventory',
            //style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            style: Theme.of(context).appBarTheme.titleTextStyle),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        onSignOutTap: () {
          // Implement sign out logic here
        },
        onFoodInventoryTap: () {
          // Navigate to food inventory screen (optional: can implement additional logic if needed)
        },
        onNutritionTap: () {
          // Navigate to nutrition screen (optional: can implement additional logic if needed)
        },
        onSettingsTap: () {
          // Navigate to settings screen (optional: can implement additional logic if needed)
        },
        onRecipesTap: () {},
          // Navigates to recipes screen
      ),
      body: ListView.builder(
        itemCount: _userFoodItems.length,
        itemBuilder: (context, index) {
          var foodItem = _userFoodItems[index];
          return ListTile(
            leading: FoodImage(
                foodId: foodItem.foodId, size: 56.0), // Display the food image
            title: Text(
              foodItem.label,
              style: Theme.of(context).textTheme.titleMedium,
            ), // Display the food name
            subtitle:
                Text('Calories: ${foodItem.getNutrientDetails("calories")}'),
            subtitleTextStyle: Theme.of(context)
                .textTheme
                .bodySmall, // Display additional details
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchFood(
                userId: _userId, // Pass the user ID to the SearchFood screen
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
