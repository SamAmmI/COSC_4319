// thought I wouldnt have to create a consumption model but for easier implementation
// I had to create one, wasnt easy to just communicate with the server for specified details
import 'package:pantree/models/food_item.dart';

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

  void calculateTotals() {
    totalCalories = totalProteins = totalCarbs = totalFats = 0.0;

    for (FoodItem item in foodItems) {
      totalCalories += (item.nutrients['ENERC_KCAL'] as double? ?? 0.0);
      totalProteins += (item.nutrients['PROCNT'] as double? ?? 0.0);
      totalCarbs += (item.nutrients['CHOCDF'] as double? ?? 0.0);
      totalFats += (item.nutrients['FAT'] as double? ?? 0.0);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'consumedAt': consumedAt,
      'userId': userId,
      'foodItems': foodItems.map((item) => item.toMap()).toList(),
      'totalCalories': totalCalories,
      'totalProteins': totalProteins,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
    };
  }

  factory UserConsumption.fromMap(Map<String, dynamic> map) {
    var foodItemsList = (map['foodItems'] as List)
        .map((itemMap) => FoodItem.fromMap(itemMap))
        .toList();

    return UserConsumption(
      consumedAt: map['consumedAt'].toDate(),
      userId: map['userId'],
      foodItems: foodItemsList,
      totalCalories: map['totalCalories'] ?? 0.0,
      totalProteins: map['totalProteins'] ?? 0.0,
      totalCarbs: map['totalCarbs'] ?? 0.0,
      totalFats: map['totalFats'] ?? 0.0,
    );
  }
}
