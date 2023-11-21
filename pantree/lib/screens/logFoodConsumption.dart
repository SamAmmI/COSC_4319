import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/models/local_user_manager.dart';
import 'package:pantree/models/user_profile.dart';
import 'package:pantree/screens/searchFoodToConsume.dart';
import 'package:pantree/screens/food_inventory_screen.dart';
import 'package:pantree/services/user_consumption_service.dart';

class LogFoodConsumption extends StatefulWidget {
  const LogFoodConsumption({Key? key}) : super(key: key);

  @override
  _LogFoodConsumptionState createState() => _LogFoodConsumptionState();
}

class _LogFoodConsumptionState extends State<LogFoodConsumption> {
  List<String> mealItems = [];

  final ConsumptionService consumptionService = ConsumptionService.instance;

  UserProfile? userProfile;

  // USER ATTRIBUTES NEEDED FOR THIS SCREEN
  double? calories;
  double? protein;
  double? carbs;
  double? fat;
  String? firstName;

  void addFoodItemToMeal(String foodItem) {
    setState(() {
      mealItems.add(foodItem);
    });
  }

  void logMeal(DocumentSnapshot foodItemDoc) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DateTime date = DateTime.now();
      bool fromInventory =
          false; // Set to true if the food item is from inventory.
      double quantity = 1.0; // Set the quantity based on user input.

      await consumptionService.logConsumptionAndUpdateTotals(
        userId,
        date,
        foodItemDoc,
        fromInventory,
        quantity,
      );

      // Optionally, you can update the UI to reflect the added food item.
      addFoodItemToMeal(
          foodItemDoc['name']); // Update the UI with the food item name.
    } catch (error) {
      // Handle any errors that may occur during the logging process.
      print('Error logging meal: $error');
    }
  }

  // WHERE WE FETCH THE PROFILE AND ATTRIBUTES
  void fetchUserProfile() async {
    final localUserManager = LocalUserManager();
    userProfile = localUserManager.getCachedUser();

    if (userProfile == null) {
      String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
      await localUserManager.fetchAndUpdateUser(userID);
      userProfile = localUserManager.getCachedUser();
    }
    if (userProfile != null) {
      calories = userProfile!.calories;
      protein = userProfile!.protein;
      carbs = userProfile!.carbs;
      fat = userProfile!.fat;
      firstName = userProfile!.firstName;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Log Meal",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchFoodToConsume(
                    userId: userId,
                    onFoodItemSelected: (foodItemDoc) {
                      logMeal(foodItemDoc as DocumentSnapshot);
                    },
                  ),
                ),
              );
            },
            child: Text("Search Food Item"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodInventoryScreen(
                    foodItems: [],
                    onFoodItemSelected: (String foodItem) {
                      // WHERE YOU NEED TO INVOKE THE FUNCTIONS TO ADJUST INVENTORY ACCORDINGLY
                    },
                  ),
                ),
              );
            },
            child: Text("Import from Food Inventory"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mealItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(mealItems[index]),
                );
              },
            ),
          ),
          // Display the nutritional information if available
          if (calories != null &&
              protein != null &&
              carbs != null &&
              fat != null)
            Text(
              'Nutritional Information:\nCalories: $calories\nProtein: $protein\nCarbs: $carbs\nFat: $fat',
              style: TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }
}
