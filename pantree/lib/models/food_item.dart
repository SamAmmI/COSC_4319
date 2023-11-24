/*
  hope to continue to work on this 'food_item' to implement better 
  retrival of data such as nutrients, catergory search,  image search
  very basic structure right now flut
*/
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

  FoodItem(
      {required this.foodId,
      required this.label,
      this.knownAs,
      this.nutrients,
      this.category,
      this.categoryLabel,
      this.image,
      this.dateTime,
      this.quantity,
      this.consumptionCount});

  FoodItem.fromFirestore(Map<String, dynamic> data)
      : foodId = data['foodId'] ?? '',
        label = data['label'] ?? '',
        image = data['image'] ?? '',
        protein = data['protein']?.toDouble(),
        carbs = data['carbs']?.toDouble(),
        fat = data['fat']?.toDouble(); // Populate fat from Firestore data

  // Add a factory constructor to create a FoodItem instance from a map
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
    // Implement the logic to update the nutrient details based on additionalInfo
    // For example:
    nutrients?['PROCNT'] =
        double.tryParse(additionalInfo['protein'] ?? '0.0')?.toStringAsFixed(2);
    nutrients?['CHOCDF.net'] =
        double.tryParse(additionalInfo['carbs'] ?? '0.0')?.toStringAsFixed(2);
    nutrients?['FAT'] =
        double.tryParse(additionalInfo['fat'] ?? '0.0')?.toStringAsFixed(2);
  }

  String getNutrientDetails(String nutrientKey) {
    return '${nutrients?[nutrientKey] ?? 'Unknown'} g';
  }
}
