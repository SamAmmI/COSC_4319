import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  String foodId;
  String label;
  String? knownAs;
  Map<String, dynamic>? nutrients;
  String? category;
  String? categoryLabel;
  String? image;
  DateTime? dateTime;
  double? protein;
  double? carbs;
  double? fat;
  double? quantity;
  double? consumptionCount;

  FoodItem({
    required this.foodId,
    required this.label,
    this.knownAs,
    this.nutrients,
    this.category,
    this.categoryLabel,
    this.image,
    this.dateTime,
    this.quantity,
    this.consumptionCount,
  });

  FoodItem.fromFirestore(Map<String, dynamic> data)
      : foodId = data['foodId'] ?? '',
        label = data['label'] ?? '',
        image = data['image'] ?? '',
        protein = data['protein']?.toDouble(),
        carbs = data['carbs']?.toDouble(),
        fat = data['fat']?.toDouble();

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      foodId: map['foodId'] ?? '',
      label: map['label'] ?? '',
      knownAs: map['knownAs'],
      nutrients: map['nutrients'],
      category: map['category'],
      categoryLabel: map['categoryLabel'],
      image: map['image'],
      dateTime: map['dateTime'] != null
          ? (map['dateTime'] as Timestamp).toDate()
          : null,
      quantity: map['quantity']?.toDouble(),
      consumptionCount: map['consumptionCount']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'label': label,
      'knownAs': knownAs,
      'nutrients': nutrients,
      'category': category,
      'categoryLabel': categoryLabel,
      'image': image,
      'dateTime': dateTime != null ? Timestamp.fromDate(dateTime!) : null,
      'quantity': quantity,
      'consumptionCount': consumptionCount,
    };
  }

  void updateNutrientsDetails(Map<String, dynamic> additionalInfo) {
    nutrients?['PROCNT'] = additionalInfo['protein'];
    nutrients?['CHOCDF.net'] = additionalInfo['carbs'];
    nutrients?['FAT'] = additionalInfo['fat'];
  }

  String getNutrientDetails(String nutrientKey) {
    return '${formatNutrientValue(nutrientKey, nutrients?[nutrientKey])}g';
  }

  static String getFormattedNutrientLabel(String nutrientKey) {
    // Implement the logic to format nutrient labels as needed
    // For example, capitalize the first letter
    return nutrientKey.isNotEmpty
        ? nutrientKey[0].toUpperCase() + nutrientKey.substring(1)
        : nutrientKey;
  }

  static String formatNutrientValue(String nutrientKey, dynamic value) {
    // Implement the logic to format nutrient values as needed
    // For example, limit decimal places to a maximum of two digits
    if (value is double) {
      return value.toStringAsFixed(2);
    } else {
      return value.toString();
    }
  }
}
