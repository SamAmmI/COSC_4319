import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/components/food_image.dart';
import 'package:pantree/services/foodService.dart';
import 'package:pantree/models/food_item.dart';
import 'package:pantree/services/user_consumption.dart';

class SearchFoodToConsume extends StatefulWidget {
  const SearchFoodToConsume({
    Key? key,
    required String userId,
    required Null Function(dynamic foodItemDoc) onFoodItemSelected,
  }) : super(key: key);

  @override
  _SearchFoodToConsumeState createState() => _SearchFoodToConsumeState();
}

class _SearchFoodToConsumeState extends State<SearchFoodToConsume> {
  final TextEditingController searchController = TextEditingController();
  FoodItem? searchedItem;
  String? errorMsg;
  bool isLoading = false;
  final FoodService foodService = FoodService();
  final ConsumptionService consumptionService = ConsumptionService.instance;

  // Add a field to store the selected food item document.
  DocumentSnapshot? selectedFoodItemDoc;

  // Method to call when adding the selected food item to consumption.
  void addToConsumption() async {
    if (selectedFoodItemDoc != null) {
      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        DateTime date = DateTime.now();

        await consumptionService.logConsumptionAndUpdateTotals(
          userId,
          date,
          selectedFoodItemDoc!,
          false,
          1.0,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Food item added to your consumption log'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add food item: $e'),
          ),
        );
      }
    }
  }

  Future<void> handleSearch() async {
    final foodName = searchController.text;
    setState(() => isLoading = true);

    try {
      final foodItem = await foodService.searchOrAddFood(foodName);
      if (foodItem != null) {
        final docSnapshot =
            await foodService.getFoodItemDocSnapshot(foodItem.foodId);
        setState(() {
          searchedItem = foodItem;
          selectedFoodItemDoc = docSnapshot;
          errorMsg = null;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Failed to get data: $e';
        searchedItem = null;
        selectedFoodItemDoc = null;
        isLoading = false;
      });
    }
  }

  String nutrientsToText(Map<String, dynamic>? nutrients) {
    if (nutrients == null) {
      return ''; // or any default value
    }

    return nutrients.entries
        .map((e) => '${searchedItem!.getNutrientDetails(e.key)}: ${e.value}')
        .join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Food for Consumption",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              children: [
                TextFormField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search for food',
                  ),
                  onFieldSubmitted: (value) async {
                    try {
                      final foodItem = await foodService.searchOrAddFood(value);
                      if (foodItem != null) {
                        final docSnapshot = await foodService
                            .getFoodItemDocSnapshot(foodItem.foodId);
                        setState(() {
                          searchedItem = foodItem;
                          selectedFoodItemDoc =
                              docSnapshot; // Update the selectedFoodItemDoc with the DocumentSnapshot
                          errorMsg = null;
                        });
                      }
                    } catch (e) {
                      setState(() {
                        errorMsg = 'Failed to fetch food data';
                        searchedItem = null;
                        selectedFoodItemDoc =
                            null; // Clear the selectedFoodItemDoc as well
                      });
                    }
                  },
                ),
                if (searchedItem != null) ...[
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      children: [
                        const TextSpan(text: 'Food Name: '),
                        TextSpan(
                          text: searchedItem!.label,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (searchedItem?.image != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: FoodImage(
                            foodId: (searchedItem!.foodId),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          '${searchedItem!.label} Nutrients:\n${nutrientsToText(searchedItem!.nutrients)}',
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (searchedItem != null) {
                        addToConsumption();
                      }
                    },
                    child: Text('Add Item to Consumption'),
                  ),
                ],
                if (errorMsg != null)
                  Text(errorMsg!, style: const TextStyle(color: Colors.red)),
              ],
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
