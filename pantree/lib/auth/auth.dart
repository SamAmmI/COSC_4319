import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/auth/login_or_register.dart';
import 'package:pantree/models/food_item.dart';
import 'package:pantree/screens/food_inventory_screen.dart';
import 'package:pantree/services/foodService.dart'; // Import FoodService to fetch user-specific food items

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FoodService foodService = FoodService();

  void _onFoodItemSelected(String foodItem) {
    // Handle the selected food item logic here
    // You can add it to the user's meal, display details, etc.
    // For now, you can print the selected food item.
    print('Selected Food Item: $foodItem');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<List<FoodItem>>(
              future: foodService
                  .getUserFoodItems(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, foodItemsSnapshot) {
                if (foodItemsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (foodItemsSnapshot.hasError) {
                  return Center(child: Text('Error fetching food items'));
                } else {
                  return FoodInventoryScreen(
                    foodItems: foodItemsSnapshot.data ?? [],
                    onFoodItemSelected: _onFoodItemSelected,
                  );
                }
              },
            );
          } else {
            return LoginOrRegister(onTap: () {});
          }
        },
      ),
    );
  }
}
