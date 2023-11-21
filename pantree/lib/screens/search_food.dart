import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/components/food_image.dart';
import 'package:pantree/services/foodService.dart';
import 'package:pantree/models/food_item.dart';

class SearchFood extends StatefulWidget {
  final String userId;
  final VoidCallback? onItemAdded;

  const SearchFood({Key? key, required this.userId, this.onItemAdded})
      : super(key: key);

  @override
  SearchFoodState createState() => SearchFoodState();
}

class SearchFoodState extends State<SearchFood> {
  final TextEditingController searchController = TextEditingController();
  FoodItem? searchedItem;
  String? errorMsg;
  bool isLoading = false;
  final FoodService foodService = FoodService();

  void addToUserDatabase(FoodItem foodItem) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await foodService.addFoodItemToUserDatabase(userId, foodItem);

      // Call the callback function to notify the FoodInventoryScreen
      if (widget.onItemAdded != null) {
        widget.onItemAdded!();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food item added to your database')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add food item')),
      );
    }
  }

  String nutrientsToText(Map<String, dynamic>? nutrients) {
    if (nutrients == null) {
      return 'Nutrient information not available';
    }

    return nutrients.entries
        .map((e) => '${searchedItem!.getNutrientDetails(e.key)}: ${e.value}')
        .join('\n');
  }

  Future<void> handleSearch() async {
    final foodName = searchController.text;
    setState(() {
      isLoading = true;
    });
    try {
      final result = await foodService.searchOrAddFood(foodName);
      if (result != null) {
        setState(() {
          searchedItem = result;
          errorMsg = null;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Failed to get data';
        searchedItem = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Food"),
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
                      final result = await foodService.searchOrAddFood(value);
                      if (result != null) {
                        setState(() {
                          searchedItem = result;
                          errorMsg = null;
                        });
                      }
                    } catch (e) {
                      setState(() {
                        errorMsg = 'Failed to fetch food data';
                        searchedItem = null;
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
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
                            '${searchedItem!.label} Nutrients:\n${nutrientsToText(searchedItem!.nutrients)}'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (searchedItem != null) {
                        addToUserDatabase(searchedItem!);
                      }
                    },
                    child: Text('Add Item'),
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
              )),
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
