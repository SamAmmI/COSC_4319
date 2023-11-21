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
  double? protein; // protein property
  double? carbs; // carbs property
  double? fat; // fat property

  FoodItem({
    required this.foodId,
    required this.label,
    this.knownAs,
    this.nutrients,
    this.category,
    this.categoryLabel,
    this.image,
    this.dateTime,
  });

  FoodItem.fromFirestore(Map<String, dynamic> data)
      : foodId = data['foodId'] ?? '',
        label = data['label'] ?? '',
        image = data['image'] ?? '',
        protein =
            data['protein']?.toDouble(), // Populate protein from Firestore data
        carbs = data['carbs']?.toDouble(), // Populate carbs from Firestore data
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
          ? (map['dateTime'] as Timestamp)
              .toDate() // Convert Timestamp to DateTime
          : null,
    );
  }

  // Add a method to convert a FoodItem instance to a map
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
    };
  }

  void updateNutrientDetails(Map<String, dynamic> additionalInfo) {
    // Implement the logic to update the nutrient details based on additionalInfo
    // For example:
    // nutrientDetails['PROCNT'] = additionalInfo['protein'];
    // nutrientDetails['CHOCDF.net'] = additionalInfo['carbs'];
    // nutrientDetails['FAT'] = additionalInfo['fat'];
  }

  // Add the missing method
  String getNutrientDetails(String nutrientKey) {
    // Implement the logic to get nutrient details based on the nutrientKey
    // For example:
    // return '${nutrientDetails[nutrientKey]}g';
    return ''; // Replace this with the actual implementation
  }
}
