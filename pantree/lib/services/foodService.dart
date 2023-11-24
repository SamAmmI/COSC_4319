import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pantree/models/food_item.dart';

class FoodService {
  final CollectionReference foodItems =
      FirebaseFirestore.instance.collection('foodItems');

  Future<FoodItem> addFoodItemToFirebase(FoodItem food) async {
    await foodItems.doc(food.foodId).set(food.toMap());
    return food;
  }

  // ONCE CONFIRMED FOOD ITEM IT FOUND ADD TO THE DATABASE
  Future<FoodItem> addFoodItemToUserDatabase(
      String userId, FoodItem food, double quantity) async {
    final now = DateTime.now();
    final foodItemRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('foodItems')
        .doc(food.foodId);

    final doc = await foodItemRef.get();

    // foodItem is in current Invenetory update the quantity, if not add food item with quantity amount
    if (doc.exists) {
      double currentQuantity = doc.data()?['quantity']?.toDouble() ?? 0;
      double updatedQuantity = currentQuantity + quantity;
      await foodItemRef.update({'quantity': updatedQuantity});
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('foodItems')
          .doc(food.foodId)
          .set({
        ...food.toMap(),
        'dateTime': now,
        'quantity': quantity,
      });
    }
    return food;
  }

  Future<void> updateUserFoodItem(FoodItem foodItem, String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('foodItems')
        .doc(foodItem.foodId)
        .update(foodItem.toMap());
  }

  Future<void> deleteUserFoodItem(FoodItem foodItem, String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('foodItems')
        .doc(foodItem.foodId)
        .delete();
  }

  // deleting food item from user utilzing the foodId directly for the consumption
  Future<void> consumedFoodItem(
      String foodId, String userId, double quantity) async {
    final foodItemRef = FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('foodItems')
        .doc(foodId);

    final doc = await foodItemRef.get();
    if (doc.exists) {
      double currentQuantity = doc.data()?['quantity']?.toDouble ?? 0;
      double updatedQuantity = currentQuantity - quantity;

      if (updatedQuantity <= 0) {
        await foodItemRef.delete();
      } else {
        await foodItemRef.update({'quantity': updatedQuantity});
      }
    }
  }

  Future<FoodItem?> searchOrAddFood(String foodName) async {
    const String apiURL = 'https://api.edamam.com/api/food-database/v2/parser';
    const String appId = 'f11d8162';
    const String appKey = 'e271a11e5e0db5ab9860827c0713bda1';

    final QuerySnapshot snapshot =
        await foodItems.where('label', isEqualTo: foodName).get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return FoodItem.fromMap(doc.data() as Map<String, dynamic>);
    }

    final response = await http.get(Uri.parse(
        '$apiURL?app_id=$appId&app_key=$appKey&ingr=$foodName&nutrition-type=logging'));

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);

      if (parsedResponse['parsed'] != null &&
          parsedResponse['parsed'].length > 0) {
        final foodData = parsedResponse['parsed'][0]['food'];

        final food = FoodItem(
            foodId: foodData['foodId'],
            label: foodData['label'],
            knownAs: foodData['knownAs'],
            nutrients: foodData['nutrients'],
            category: foodData['category'],
            categoryLabel: foodData['categoryLabel'],
            image: foodData['image'],
            dateTime: null,
            quantity: null,
            consumptionCount: null);

        await addFoodItemToFirebase(food);

        return food;
      }
    } else {
      throw Exception('Failed to fetch food data');
    }
    return null;
  }

  Future<String?> fetchFoodImageLink(String foodId) async {
    DocumentSnapshot doc = await foodItems.doc(foodId).get();

    if (doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return data['image'];
    }
    return null;
  }

  Future<DocumentSnapshot?> getFoodItemDocSnapshot(String foodId) async {
    try {
      final QuerySnapshot snapshot =
          await foodItems.where('foodId', isEqualTo: foodId).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first;
      }
    } catch (e) {
      print('Error fetching document snapshot: $e');
    }
    return null;
  }

  fetchAdditionalInfo(String foodId) {}

  getUserFoodItems(String uid) {}
}
