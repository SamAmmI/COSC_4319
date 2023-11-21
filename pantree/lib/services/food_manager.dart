import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pantree/models/food_item.dart';

class FoodManagement {
  final String userId;

  FoodManagement(this.userId);

  Future<List<FoodItem>> getUserFoodItems() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('foodItems')
          .orderBy('dateTime',
              descending: true) // Order by dateTime in descending order
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FoodItem.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching food items: $e');
      return [];
    }
  }
}

Future<void> addFoodItem(FoodItem foodItem) async {
  try {
    String? userId;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('foodItems')
        .add(foodItem.toMap());
  } catch (e) {
    print('Error adding food item: $e');
  }
}

// Example method for updating a food item
Future<void> updateFoodItem(FoodItem foodItem) async {
  try {
    String? userId;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('foodItems')
        .doc(foodItem.foodId)
        .update(foodItem.toMap());
  } catch (e) {
    print('Error updating food item: $e');
  }
}

// Example method for deleting a food item
Future<void> deleteFoodItem(String foodItemId) async {
  try {
    String? userId;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('foodItems')
        .doc(foodItemId)
        .delete();
  } catch (e) {
    print('Error deleting food item: $e');
  }
}
