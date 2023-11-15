import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pantree/models/food_item.dart';

class FoodManagement {
  final String userId;

  FoodManagement(this.userId);

  Future<List<FoodItem>> getUserFoodItems() async {
    //function to get user food list
    CollectionReference userFoodItems = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('foodItems');

    QuerySnapshot querySnapshot = await userFoodItems.get();

    return querySnapshot.docs
        .map((doc) => FoodItem.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
