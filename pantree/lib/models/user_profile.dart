/*
 this class will hold the necessary attributes 
 for the User Profile
*/

class UserProfile {
  final String userID;
  String firstName;
  String lastName;

  // nullable attributes up to user if they want to provide these details
  double? height; // needs to be in m
  double? weight;
  double? age;
  double? goalWeight; // needs to be in kg
  String? sex; // M or F, male or female
  double? calorieGoal;
  double? carbGoal;
  double? proteinGoal;
  double? fatGoal;

  UserProfile({
    required this.userID,
    required this.firstName,
    required this.lastName,
    double? height,
    double? weight,
    double? age,
    double? goalWeight,
    String? sex,
  }) : super() {
    // where we set the user's initial macro goals
    this.height = height;
    this.weight = weight;
    this.age = age;
    this.sex = sex;

    Map<String, double> initialMacroCalc = calcMacros();
    calorieGoal = initialMacroCalc['Calories'];
    carbGoal = initialMacroCalc['Carbs'];
    proteinGoal = initialMacroCalc['Protein'];
    fatGoal = initialMacroCalc['Fat'];
  }

  double? get protein => null;

  double? get calories => null;

  double? get carbs => null;

  double? get fat => null;

  set profilePictureUrl(profilePictureUrl) {}

  // method to store user data into firebase
  Map<String, dynamic> toMap() {
    Map<String, double> macros = calcMacros();
    return {
      'userID': userID,
      'firstName': firstName,
      'lastName': lastName,
      'height': height,
      'weight': weight,
      'age': age,
      'goalWeight': goalWeight,
      'sex': sex,
      'Macros': {
        'Calories': macros['Calories'],
        'Carbs': macros['Carbs'],
        'Protein': macros['Protein'],
        'Fat': macros['Fat']
      }
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userID: map['userID'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      height: map['height']?.toDouble() ?? 0.0,
      weight: map['weight']?.toDouble() ?? 0.0,
      age: map['age']?.toDouble() ?? 0.0,
      goalWeight: map['goalWeight']?.toDouble() ?? 0.0,
      sex: map['sex'],
    )
      ..calorieGoal = map['Macros']['Calories']
      ..carbGoal = map['Macros']['Carbs']
      ..proteinGoal = map['Macros']['Protein']
      ..fatGoal = map['Macros']['Fat'];
  }

  double calcBMR() {
    double weightKg = poundsToKg(weight!);
    if (sex == 'M') {
      return 10 * weightKg + 6.25 * height! - 5 * age! + 5;
    } else {
      return 10 * weightKg + 6.25 * height! - 5 * age! - 161;
    }
  }

  double poundsToKg(double pounds) {
    return pounds / 2.20462;
  }

  double calcTDEE() {
    double bmr = calcBMR();
    double activity =
        1.2; // This could be a variable factor based on the actual activity level of the user
    return bmr * activity;
  }

  Map<String, double> calcMacros() {
    double TDEE = calcTDEE();
    double carbs = TDEE * .5 / 4; // calories per gram
    double protein = TDEE * .2 / 4; // calories per gram
    double fat = TDEE * .3 / 9; // calories per gram
    return {'Calories': TDEE, 'Carbs': carbs, 'Protein': protein, 'Fat': fat};
  }

  void updateGoals(String macro, double value) {
    switch (macro) {
      case 'Calories':
        calorieGoal = value;
        break;
      case 'Carbs':
        carbGoal = value;
        break;
      case 'Protein':
        proteinGoal = value;
        break;
      case 'Fat':
        fatGoal = value;
        break;
    }
  }
}
