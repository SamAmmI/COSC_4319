import 'package:pantree/models/food_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserConsumption {
  DateTime consumedAt;
  String userId;
  List<FoodItem> foodItems;
  double totalCalories;
  double totalProteins;
  double totalCarbs;
  double totalFats;

  UserConsumption({
    required this.consumedAt,
    required this.userId,
    this.foodItems = const [],
    this.totalCalories = 0.0,
    this.totalProteins = 0.0,
    this.totalCarbs = 0.0,
    this.totalFats = 0.0,
  });

  // Calculate total nutrients from food items
  void calculateTotals() {
    totalCalories = totalProteins = totalCarbs = totalFats = 0.0;
    for (FoodItem item in foodItems) {
      totalCalories += (item.nutrients?['ENERC_KCAL'] as double? ?? 0.0);
      totalProteins += (item.nutrients?['PROCNT'] as double? ?? 0.0);
      totalCarbs += (item.nutrients?['CHOCDF'] as double? ?? 0.0);
      totalFats += (item.nutrients?['FAT'] as double? ?? 0.0);
    }
  }

  // Convert the instance to a map
  Map<String, dynamic> toMap() {
    return {
      'consumedAt': Timestamp.fromDate(consumedAt),
      'userId': userId,
      'foodItems': foodItems.map((item) => item.toMap()).toList(),
      'totalCalories': totalCalories,
      'totalProteins': totalProteins,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
    };
  }

  factory UserConsumption.fromMap(Map<String, dynamic> map) {
    var foodItemsList = (map['foodItems'] as List?)
            ?.map(
                (itemMap) => FoodItem.fromMap(itemMap as Map<String, dynamic>))
            .toList() ??
        [];

    // Check if 'consumedAt' is not null before casting
    DateTime? consumedAtDate;
    if (map['consumedAt'] != null) {
      consumedAtDate = (map['consumedAt'] as Timestamp).toDate();
    } else {
      // Handle the case where 'consumedAt' is null
      // For example, use the current date, or handle it according to your business logic
      consumedAtDate = DateTime.now();
    }

    return UserConsumption(
      consumedAt: consumedAtDate,
      userId: map['userId'] ?? '',
      foodItems: foodItemsList,
      totalCalories: map['totalCalories']?.toDouble() ?? 0.0,
      totalProteins: map['totalProteins']?.toDouble() ?? 0.0,
      totalCarbs: map['totalCarbs']?.toDouble() ?? 0.0,
      totalFats: map['totalFats']?.toDouble() ?? 0.0,
    );
  }
}
