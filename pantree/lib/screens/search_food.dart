import 'package:flutter/material.dart';
import 'package:pantree/services/foodService.dart';
import 'package:pantree/models/food_item.dart';
import 'package:pantree/components/food_image.dart';

class searchFood extends StatefulWidget {
  const searchFood({Key? key}) : super(key: key);

  @override
  searchFoodState createState() => searchFoodState();
}

class searchFoodState extends State<searchFood> {
  final TextEditingController searchController = TextEditingController();
  FoodItem? searchedItem; // To store the search result.
  String? errorMsg; // To show anyerrorMsg messages.

  final FoodService foodService = FoodService();

  bool isLoading = false;

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

  // method to assist in the output of the given nutrition facts
  String nutrientsToText(Map<String, dynamic> nutrients) {
    return nutrients.entries
        .map((e) => '${searchedItem!.getNutrientDetails(e.key)}: ${e.value}')
        .join('\n');
  }

  // WIDGET OF LOG MEAL SCREEN
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
