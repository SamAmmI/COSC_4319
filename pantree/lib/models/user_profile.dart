/*
 this class will hold the necessary attributes 
 for the User Profile
*/

class UserProfile {
  final String userID;
  String firstName;
  String lastName;

  // nullable attributes up to user if they want to provide these details
  double? height; //needs to be in m
  double? weight;
  double? age;
  double? goalWeight; // needs to be in kg
  String? sex; // M or F, male or female
  double? calorieGoal;
  double? carbGoal;
  double? proteinGoal;
  double? fatGoal;

  //class constructor
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
    // where we set the user's inital macro goals
    this.height = height;
    this.weight = weight;
    this.age = age;
    this.sex = sex;

    Map<String, dynamic> inititalMacroCalc = calcMacros();
    calorieGoal = inititalMacroCalc['Calories'];
    carbGoal = inititalMacroCalc['Carbs'];
    proteinGoal = inititalMacroCalc['Protein'];
    fatGoal = inititalMacroCalc['Fat'];
  }

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

  // factory method, used to either create a new 'User' or return existing 'User' from firebase
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

  /* BELOW IS WHERE WE CALC NUTRITIONAL GOALS PER USER
     - Mifflin-St Jeor Equation is used for calculating BMR
        For men: BMR = 10 * weight (kg) + 6.25 * height (cm) - 5 * age (y) + 5
        For women: BMR = 10 * weight (kg) + 6.25 * height (cm) - 5 * age (y) - 161

     - TDEE is estimated by multiplying the BMR by an activity factor
        using a general constant of (1.2) for general use

     - We then use both of these to calculate macros per user
  */
  // BMR calculation adjusted for US customary units
  double calcBMR() {
    double weightKg = poundsToKg(weight!); // Ensure 'weight' is in pounds

    if (sex == 'M') {
      return 10 * weightKg + 6.25 * height! - 5 * age! + 5;
    } else {
      return 10 * weightKg + 6.25 * height! - 5 * age! - 161;
    }
  }

  // Conversion helper methods
  double poundsToKg(double pounds) {
    return pounds / 2.20462;
  }

  // TDEE calculation remains the same as it uses the output from calcBMR
  double calcTDEE() {
    double bmr = calcBMR();
    double activity =
        1.2; // This could be a variable factor based on the actual activity level of the user
    return bmr * activity;
  }

  Map<String, double> calcMacros() {
    double TDEE = calcTDEE();

    // using base calc 50% carbs, 20% protein, 30% fat
    double carbs = TDEE * .5 / 4; // calories per gram
    double protein = TDEE * .2 / 4; // calories per gram
    double fat = TDEE * .3 / 9; // calories per gram

    return {'Calories': TDEE, 'Carbs': carbs, 'Protein': protein, 'Fat': fat};
  }

  //CONVERSION METHODS BECAUSE OF AMERICAN NUMERICAL STANDARDS
  numericalConversion(double value) {}

  //METHOD TO UPDATE ANY GOALS TRIGGERED BY USER
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
