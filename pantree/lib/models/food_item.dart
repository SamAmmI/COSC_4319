/*
  hope to continue to work on this 'food_item' to implement better 
  retrival of data such as nutrients, catergory search,  image search
  very basic structure right now flut
*/
class FoodItem{

  final String foodId;
  final String label;
  final String knownAs;
  
  final Map<String, dynamic> nutrients;
  final String category;
  final String categoryLabel;
  final String image;

  // constructor of the class with the given fields
  FoodItem({
    required this.foodId, 
    required this.label, 
    required this.knownAs,
    required this.nutrients, 
    required this.category,
    required this.categoryLabel,
    required this.image
    });

  // will store this object to a map
  Map<String, dynamic> toMap() {
    return{
      'foodId': foodId,
      'label': label,
      'knownAs': knownAs,
      'nutrients': nutrients,
      'category': category,
      'categoryLabel': categoryLabel,
      'image': image
    };
  }

  static FoodItem fromMap(Map<String, dynamic> map) {
    return FoodItem(
      foodId: map['foodId'],
      label: map['label'],
      knownAs: map['knownAs'],
      nutrients: map['nutrients'],
      category: map['category'],
      categoryLabel: map['categoryLabel'],
      image: map['image'],
    );
  }

  // api returns nutrient details in similar format implemented this to translate when needed
  String getNutrientDetails(String nutrientKey) {
    
    Map<String, String> nutrientNames = {
      "name": "Name",
      "calories": "Calories",
      "category": "Category",
      "CHOCDF": "Carbohydrate g",
      "CHOCDF.net":"Carbohydrates(net) g",
      "CHOLE":"Cholesterol mg",
      "ENERC_KCAL":"Energy",
      "FAMS":"Monosaturated g",
      "FAPU":"Polyunsaturated g",
      "FASAT":"Total Saturated g",
      "FAT":"Fat g",
      "FATRN":"Total Trans Fatty Acids g",
      "FE":"Iron mg",
      "FIBTG":"Total Dietary Fiber g",
      "FOLAC":"Folic Acid",
      "FOLDFE":"Foloate",
      "FOLFD":"Folate(food)",
      "K":"Potassium mg",
      "MG":"Magnesium mg",
      "NA":"Sodium mg",
      "NIA":"Niacin mg",
      "P":"Phosphorus mg",
      "PROCNT":"Protein g",
      "RIBF":"Riboflavin g",
      "SUGAR":"Sugar h",
      "SUGAR.added":"Sugars Added g",
      "Sugar.alcohol":"Surgar Alchohols g",
      "THIA":"Thiamin mg",
      "TOCPHA":"Vitamin E",
      "VITA_RAE":"Vitamin A RAE",
      "VITB12":"Vitamin B12",
      "VITB6A":"Vitamin B6",
      "VITC":"Vitamin C",
      "VITD":"Vitamin D",
      "VITK1":"Vitamin k",
      "WATER":"Water g",
      "ZN":"Zinc mg",
    };

    return nutrientNames[nutrientKey] ?? 'Unknown';
  }
}