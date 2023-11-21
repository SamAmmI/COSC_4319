import 'package:flutter/material.dart';
import 'package:pantree/models/food_item.dart';

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
    proteinController.text =
        widget.foodItem.nutrients?['PROCNT'].toString() ?? '';
    carbsController.text =
        widget.foodItem.nutrients?['CHOCDF'].toString() ?? '';
    fatsController.text = widget.foodItem.nutrients?['FAT'].toString() ?? '';
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
    widget.foodItem.nutrients?['PROCNT'] =
        double.tryParse(proteinController.text) ?? 0.0;
    widget.foodItem.nutrients?['CHOCDF'] =
        double.tryParse(carbsController.text) ?? 0.0;
    widget.foodItem.nutrients?['FAT'] =
        double.tryParse(fatsController.text) ?? 0.0;

    // Implement logic to update data in Firebase
    // Assuming you have a method in FoodService to update the data
    // Update the food item in the user's specific collection in Firebase
    // await FoodService().updateUserFoodItem(widget.foodItem);

    // Notify parent screen about the update
    widget.onUpdate();

    // Navigate back
    Navigator.pop(context);
  }
}
