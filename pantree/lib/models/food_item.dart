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
          ? (map['dateTime'] as Timestamp)
              .toDate() // Convert Timestamp to DateTime
          : null,
      quantity: map['quantity']?.toDouble(), // quantity
      consumptionCount: map['consumptionCount']?.toDouble(), //consumptionCount
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
      'quantity': quantity, // quantity
      'consumptionCount': consumptionCount, // consumptionCount
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
    Map<String, String> nutrientNames = {
      "name": "Name",
      "calories": "Calories",
      "category": "Category",
      "carbs": "Carbohydrates (g)",
      "CHOCDF.net": "Carbohydrates(net) g",
      "CHOLE": "Cholesterol (mg)",
      "ENERC_KCAL": "Energy",
      "FAMS": "Monosaturated (g)",
      "FAPU": "Polyunsaturated (g)",
      "FASAT": "Total Saturated (g)",
      "fat": "Fat (g)",
      "FATRN": "Total Trans Fatty Acids (g)",
      "FE": "Iron mg",
      "FIBTG": "Total Dietary Fiber (g)",
      "FOLAC": "Folic Acid",
      "FOLDFE": "Foloate",
      "FOLFD": "Folate(food)",
      "K": "Potassium (mg)",
      "MG": "Magnesium (mg)",
      "NA": "Sodium (mg)",
      "NIA": "Niacin (mg)",
      "P": "Phosphorus (mg)",
      "protein": "Protein (g)",
      "RIBF": "Riboflavin (g)",
      "SUGAR": "Sugar h",
      "SUGAR.added": "Sugars Added (g)",
      "Sugar.alcohol": "Surgar Alchohols (g)",
      "THIA": "Thiamin (mg)",
      "TOCPHA": "Vitamin E",
      "VITA_RAE": "Vitamin A RAE",
      "VITB12": "Vitamin B12",
      "VITB6A": "Vitamin B6",
      "VITC": "Vitamin C",
      "VITD": "Vitamin D",
      "VITK1": "Vitamin k",
      "WATER": "Water (g)",
      "ZN": "Zinc (mg)",
    };

    return nutrientNames[nutrientKey] ?? 'Unknown';
  }
}
