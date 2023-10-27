import 'package:flutter/material.dart';
import 'package:pantree/services/food_api_service.dart';  
import 'package:pantree/models/food_item.dart';

class LogMeal extends StatefulWidget {
  const LogMeal({Key? key}) : super(key: key);

  @override
  _LogMealState createState() => _LogMealState();
}

class _LogMealState extends State<LogMeal> {
  final TextEditingController _searchController = TextEditingController();
  FoodItem? searchedItem;  // To store the search result.
  String? errorMsg;  // To show anyerrorMsg messages.

  Future<void> _handleSearch() async {
    final foodName = _searchController.text;
    try{
      final result = await searchOrAddFood(foodName);
      if (result != null){
        setState(() {
          searchedItem = result;
          errorMsg = null;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Failed to get data';
        searchedItem = null;
      });
    }
  }

  // method to assist in the output of the given nutrition facts
  String nutrientsToText(Map<String, dynamic> nutrients) {
    return nutrients.entries
        .map((e) => '${searchedItem!.getNutrientDetails(e.key)}: ${e.value}')
        .join('\n');
  }

  // WIDGET of this Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log a Meal"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search for food',
              ),
              onFieldSubmitted: (value) async {
                try {
                  final result = await searchOrAddFood(value);
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
            if (searchedItem != null)
              ...[
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    children: [
                      const TextSpan(text: 'Food Name: '),
                      TextSpan(text: searchedItem!.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ], 
                  ),
                ),
                const Divider(thickness: 2,),
                Text(
                  '${searchedItem!.label} Nutrients:\n${nutrientsToText(searchedItem!.nutrients)}'
                ),
              ],
            if (errorMsg != null)
              Text(errorMsg!, style: const TextStyle(color: Colors.red)),
            ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
