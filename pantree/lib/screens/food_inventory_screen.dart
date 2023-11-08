import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/components/drawer.dart';
import 'package:pantree/screens/add_food_screen.dart';
import 'package:pantree/models/food_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pantree/screens/search_food.dart';

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

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    _user = _auth.currentUser!;
    _userId = _user.uid;
    _getUserFoodItems();
  }

  Future<void> _getUserFoodItems() async {
    // Reference to the user's specific food items collection in Firestore
    CollectionReference userFoodItems = FirebaseFirestore.instance
        .collection('Users')
        .doc(_userId)
        .collection('foodItems');

    // Retrieve the user's food items from Firestore
    QuerySnapshot querySnapshot = await userFoodItems.get();

    setState(() {
      // Clear the previous user food items
      _userFoodItems.clear();

      // Add the retrieved food items to the list
      _userFoodItems.addAll(
        querySnapshot.docs
            .map((doc) => FoodItem.fromMap(doc.data() as Map<String, dynamic>))
            .toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Inventory',
            style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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
      ),
      body: ListView.builder(
        itemCount: _userFoodItems.length,
        itemBuilder: (context, index) {
          var foodItem = _userFoodItems[index];
          return ListTile(
            title: Text(foodItem.getNutrientDetails("name")),
            subtitle:
                Text('${foodItem.getNutrientDetails("calories")} calories'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchFood(
                userId: '',
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
