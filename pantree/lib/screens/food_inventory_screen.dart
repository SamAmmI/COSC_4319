import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/components/drawer.dart';
import 'package:pantree/models/food_item.dart';
import 'package:pantree/screens/search_food.dart';
import 'package:pantree/components/food_image.dart';
import 'package:pantree/services/food_manager.dart';
import 'package:pantree/services/foodService.dart';
import 'package:pantree/auth/auth.dart'; // Import FoodService
import 'package:pantree/components/settings_drawer.dart';

class FoodInventoryScreen extends StatefulWidget {
  final List<FoodItem> foodItems;
  final void Function(String foodItem) onFoodItemSelected;

  const FoodInventoryScreen({
    Key? key,
    required this.foodItems,
    required this.onFoodItemSelected,
  }) : super(key: key);

  @override
  _FoodInventoryScreenState createState() => _FoodInventoryScreenState();
}

class _FoodInventoryScreenState extends State<FoodInventoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  late String _userId;
  List<FoodItem> _userFoodItems = [];

  late FoodManagement _foodManagement;
  late FoodService _foodService; // Initialize FoodService

  @override
  void initState() {
    super.initState();
    _getUser();
    _foodService = FoodService(); // Initialize FoodService
  }

  Future<void> _getUser() async {
    _user = _auth.currentUser!;
    _userId = _user.uid;

    _foodManagement = FoodManagement(_userId);
    _getUserFoodItems();
  }

  Future<void> _getUserFoodItems() async {
    List<FoodItem> userFoodItems = await _foodManagement.getUserFoodItems();

    // Fetch additional information for each food item from the API
    for (var foodItem in userFoodItems) {
      var additionalInfo =
          await _foodService.fetchAdditionalInfo(foodItem.foodId);
      if (additionalInfo != null) {
        foodItem
            .updateNutrientDetails(additionalInfo); // Update nutrient details
      }
    }

    setState(() {
      _userFoodItems = userFoodItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Inventory',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      drawer: Settings_Drawer(
        onSettingsTap: () {
          // Navigate to settings screen (optional: can implement additional logic if needed)
        },
      ),
      body: ListView.builder(
        itemCount: _userFoodItems.length,
        itemBuilder: (context, index) {
          var foodItem = _userFoodItems[index];
          return ListTile(
            leading: FoodImage(
              foodId: foodItem.foodId,
              size: 56.0,
            ),
            title: Text(
              foodItem.label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  TextSpan(
                    text:
                        'Proteins: ${foodItem.getNutrientDetails("PROCNT")}g, ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'Carbs: ${foodItem.getNutrientDetails("CHOCDF.net")}g, ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Fats: ${foodItem.getNutrientDetails("FAT")}g\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (String choice) {
                if (choice == 'edit') {
                  _editNutrientInfo(foodItem);
                } else if (choice == 'delete') {
                  _deleteFoodItem(foodItem);
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                    ),
                  ),
                  // Add more options if needed
                ];
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Wait for the SearchFood screen to return a result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchFood(
                userId: _userId,
                onItemAdded: () {
                  // Callback function to refresh the food items after adding
                  _getUserFoodItems();
                },
              ),
            ),
          );

          // Handle the result if needed
          // For example, you can check if the result is not null and take action
          if (result != null) {
            // Do something with the result
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Color(0xFF1e643b),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void _editNutrientInfo(FoodItem foodItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNutrientScreen(
          foodItem: foodItem,
          onUpdate: () {
            // Implement logic to refresh the food items after updating
            _getUserFoodItems();
          },
        ),
      ),
    );
  }

  void _deleteFoodItem(FoodItem foodItem) async {
    try {
      // Delete the food item from Firebase
      await FoodService().deleteUserFoodItem(foodItem, _userId as String);

      // Notify parent screen about the update
      _getUserFoodItems();
    } catch (e) {
      // Handle errors, if any
      print('Error deleting food item: $e');
      // You might want to show an error message to the user
    }
  }
}

class EditNutrientScreen extends StatefulWidget {
  final FoodItem foodItem;
  final VoidCallback onUpdate;

  EditNutrientScreen({
    required this.foodItem,
    required this.onUpdate,
  });

  @override
  _EditNutrientScreenState createState() => _EditNutrientScreenState();
}

class _EditNutrientScreenState extends State<EditNutrientScreen> {
  TextEditingController proteinController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController fatsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    proteinController.text = widget.foodItem.nutrients['PROCNT'].toString();
    carbsController.text = widget.foodItem.nutrients['CHOCDF'].toString();
    fatsController.text = widget.foodItem.nutrients['FAT'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Nutrients'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Proteins (g):'),
            TextField(
              controller: proteinController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            Text('Carbs (g):'),
            TextField(
              controller: carbsController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            Text('Fats (g):'),
            TextField(
              controller: fatsController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateNutrients();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateNutrients() async {
    // Update the nutrient values
    widget.foodItem.nutrients['PROCNT'] =
        double.tryParse(proteinController.text) ?? 0.0;
    widget.foodItem.nutrients['CHOCDF'] =
        double.tryParse(carbsController.text) ?? 0.0;
    widget.foodItem.nutrients['FAT'] =
        double.tryParse(fatsController.text) ?? 0.0;

    try {
      // Update the food item in Firebase
      await FoodService()
          .updateUserFoodItem(widget.foodItem, _userId as String);

      // Notify parent screen about the update
      widget.onUpdate();

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      // Handle errors, if any
      print('Error updating nutrient values: $e');
      // You might want to show an error message to the user
    }
  }
}

class _userId {}
