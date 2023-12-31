import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pantree/models/food_item.dart';
import 'package:pantree/screens/search_food.dart';
import 'package:pantree/components/food_image.dart';
import 'package:pantree/services/food_manager.dart';
import 'package:pantree/services/foodService.dart';
import 'package:pantree/auth/auth.dart';
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
  late FoodService _foodService;

  @override
  void initState() {
    super.initState();
    _getUser();
    _foodService = FoodService();
  }

  Future<void> _getUser() async {
    _user = _auth.currentUser!;
    _userId = _user.uid;

    _foodManagement = FoodManagement(_userId);
    await _getUserFoodItems();
  }

  Future<void> _getUserFoodItems() async {
    List<FoodItem> userFoodItems = await _foodManagement.getUserFoodItems();

    for (var foodItem in userFoodItems) {
      var additionalInfo =
          await _foodService.fetchAdditionalInfo(foodItem.foodId);
      if (additionalInfo != null) {
        foodItem.updateNutrientsDetails(additionalInfo);
      }
    }

    setState(() {
      _userFoodItems = userFoodItems;
    });
  }

  Map<String, List<FoodItem>> groupItemsByDate(List<FoodItem> items) {
    Map<String, List<FoodItem>> groupedItems = {};

    for (var item in items) {
      final dateKey = item.dateTime?.toLocal().toString().split(' ')[0];
      groupedItems.putIfAbsent(dateKey!, () => []);
      groupedItems[dateKey]!.add(item);
    }

    return groupedItems;
  }

  @override
  Widget build(BuildContext context) {
    final groupedItems = groupItemsByDate(_userFoodItems);

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
      body: _userFoodItems.isEmpty
          ? Center(
              child: Text(
                'Your food inventory is empty. Add items by tapping the + button.',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          : ListView.builder(
              itemCount: groupedItems.length,
              itemBuilder: (context, index) {
                final dateKey = groupedItems.keys.elementAt(index);
                final foodItems = groupedItems[dateKey]!;

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat.yMd().format(foodItems[0].dateTime!),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: foodItems.length,
                        itemBuilder: (context, index) {
                          var foodItem = foodItems[index];
                          return ListTile(
                            leading: FoodImage(
                              foodId: foodItem.foodId,
                              size: 56.0,
                            ),
                            title: Row(
                              children: [
                                // Add category icon or badge here if available
                                Icon(Icons.category),
                                SizedBox(width: 8),
                                Text(
                                  foodItem.label,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Spacer(),
                                Text(
                                  'Qty: ${foodItem.quantity}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Proteins: ${foodItem.getNutrientDetails("PROCNT")}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),
                                Text(
                                  'Carbs: ${foodItem.getNutrientDetails("CHOCDF")}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),
                                Text(
                                  'Fats: ${foodItem.getNutrientDetails("FAT")}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            subtitleTextStyle:
                                Theme.of(context).textTheme.bodySmall,
                            trailing: PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert, color: Colors.grey),
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
                                ];
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchFood(
                userId: _userId,
                onItemAdded: () {
                  _getUserFoodItems();
                },
              ),
            ),
          );

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
          onUpdate: () async {
            // Implement logic to refresh the food items after updating
            await _getUserFoodItems();
          },
        ),
      ),
    );
  }

  void _deleteFoodItem(FoodItem foodItem) async {
    try {
      // Delete the food item from Firebase
      await FoodService().deleteUserFoodItem(foodItem, _userId);

      // Notify parent screen about the update
      await _getUserFoodItems();
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
  late TextEditingController proteinController;
  late TextEditingController carbsController;
  late TextEditingController fatsController;
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    proteinController = TextEditingController(
        text: widget.foodItem.getNutrientDetails("PROCNT").replaceAll("g", ""));
    carbsController = TextEditingController(
        text: widget.foodItem
            .getNutrientDetails("CHOCDF.net")
            .replaceAll("g", ""));
    fatsController = TextEditingController(
        text: widget.foodItem.getNutrientDetails("FAT").replaceAll("g", ""));
    quantityController =
        TextEditingController(text: widget.foodItem.quantity.toString());
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
            Text('Proteins:'),
            TextField(
              controller: proteinController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            Text('Carbs:'),
            TextField(
              controller: carbsController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            Text('Fats:'),
            TextField(
              controller: fatsController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            Text('Quantity:'),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter quantity',
              ),
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
    widget.foodItem.nutrients?['PROCNT'] =
        double.tryParse(proteinController.text) ?? 0.0;
    widget.foodItem.nutrients?['CHOCDF.net'] =
        double.tryParse(carbsController.text) ?? 0.0;
    widget.foodItem.nutrients?['FAT'] =
        double.tryParse(fatsController.text) ?? 0.0;

    // Update the quantity
    widget.foodItem.quantity =
        double.tryParse(quantityController.text) ?? widget.foodItem.quantity;

    try {
      // Update the food item in Firebase
      await FoodService().updateUserFoodItem(
          widget.foodItem, FirebaseAuth.instance.currentUser!.uid);

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
