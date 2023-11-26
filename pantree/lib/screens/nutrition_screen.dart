import 'package:flutter/material.dart';
import 'package:pantree/components/settings_drawer.dart';
import 'package:pantree/models/user_consumption_model.dart';
import 'package:pantree/models/user_profile.dart';
import 'package:pantree/screens/daily_consumptionBarGraph.dart';
import 'package:pantree/screens/logFoodConsumption.dart';
import 'package:pantree/screens/nutritional_preferences.dart';
import 'package:pantree/screens/daily_consumption.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/models/local_user_manager.dart';
import 'package:pantree/components/vertical_info_card.dart';
import 'package:pantree/services/user_consumption_service.dart';
import 'package:pie_chart/pie_chart.dart';

class NutritionCard extends StatelessWidget {
  final Map<String, double>? nutritionalData;
  final double? currentCalories;
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final VoidCallback onTap;

  NutritionCard({
    Key? key,
    this.nutritionalData,
    this.currentCalories,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 400,
          height: 180,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).appBarTheme.backgroundColor ??
                  Colors.black ??
                  Colors.white),
          child: Row(
            children: [
              if (nutritionalData != null)
                Expanded(
                  flex: 2,
                  child: buildPieChart(context, currentCalories ?? 0,
                      calories ?? 2000), // Updated line
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Consumption',
                      style: TextStyle(
                          fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize ??
                              18,
                          fontWeight: FontWeight.bold)),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    height: 2,
                    color: Colors.black,
                  ),
                  Text(
                    'Calories: ${currentCalories?.round() ?? 'N/A'} kcal',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Proteins: ${protein?.round() ?? 'N/A'} g',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Carbs: ${carbs?.round() ?? 'N/A'} g',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Fats: ${fat?.round() ?? 'N/A'} g',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPieChart(
      BuildContext context, double currentCalories, double calorieGoal) {
    double remainingCalories = calorieGoal - currentCalories;
    bool isGoalExceeded = remainingCalories < 0;

    Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    double exceededAmount = isGoalExceeded ? -remainingCalories : 0.0;

    Map<String, double> data = {
      "Consumed": currentCalories.round().roundToDouble(),
      "Remaining":
          isGoalExceeded ? 0 : remainingCalories.round().roundToDouble(),
      "Exceeded": isGoalExceeded ? exceededAmount : 0,
    };

    List<Color> colorList = isGoalExceeded
        ? [Colors.red, Colors.grey]
        : [Colors.green, Colors.grey];

    return PieChart(
      dataMap: data,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius:
          MediaQuery.of(context).size.width / 3.0, // Adjust size as needed
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 20,
      centerText:
          isGoalExceeded ? "Exceeded\n${exceededAmount.round()} kcal" : "",

      legendOptions: LegendOptions(
        showLegends: false,
        legendPosition: LegendPosition.right,
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: !isGoalExceeded,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 0,
        chartValueStyle: TextStyle(
            color: textColor, fontWeight: FontWeight.normal, fontSize: 12),
      ),
    );
  }
}

class nutrition_screen extends StatefulWidget {
  const nutrition_screen({Key? key});

  @override
  State<nutrition_screen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<nutrition_screen> {
  String? userEmail;
  UserProfile? userProfile;
  UserConsumption? currentConsumption;
  ConsumptionService? consumptionService;

  // USER ATTRIBUTES NEEDED FOR THIS SCREEN
  double? calories;
  double? protein;
  double? carbs;
  double? fat;
  String? firstName;
  double? caloriesConsumed;
  double? proteinConsumed;
  double? carbsConsumed;
  double? fatsConsumed;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchCurrentConsumption();
  }

  // WHERE WE FETCH THE USER CURRENT CONSUMPTION
  Future<void> fetchCurrentConsumption() async {
    String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    try {
      DateTime currentDate = DateTime.now();
      var consumptionData = await ConsumptionService.instance
          .getUserConsumptionData(userID, currentDate);
      print('Fetched Data: $consumptionData');
      setState(() {
        currentConsumption = consumptionData;
      });
    } catch (e) {
      print('Error fetching consumption data: $e');
    }
  }

  // WHERE WE FETCH THE PROFILE AND ATTRIBUTES
  void fetchUserProfile() async {
    final localUserManager = LocalUserManager();
    userProfile = localUserManager.getCachedUser();

    if (userProfile == null) {
      String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
      await localUserManager.fetchAndUpdateUser(userID);
      userProfile = localUserManager.getCachedUser();
    }
    if (userProfile != null) {
      calories = localUserManager.getUserAttribute('Calories') as double?;
      protein = localUserManager.getUserAttribute('Protein') as double?;
      carbs = localUserManager.getUserAttribute('Carbs') as double?;
      fat = localUserManager.getUserAttribute('Fat') as double?;
      firstName = localUserManager.getUserAttribute('firstName') as String?;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextStyle nutrientNameStyle = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontSize: 16, fontWeight: FontWeight.bold);

    TextStyle nutrientValueStyle =
        Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nutrition",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),

      //BELOW IS THE BODY OF THE SCREEN
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${firstName ?? 'User'}", //"Hello, ${userName ?? 'User'}", TO GET THE USERNAME FROM DB
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            Text(
              "Daily Overview",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              child: Column(
                children: [
                  // CARD 1 USER CONSUMPTION DETAILS
                  SingleChildScrollView(
                    child: Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NutriTrack(),
                            ),
                          );
                        },
                        child: Card(
                          color:
                              Theme.of(context).appBarTheme.backgroundColor ??
                                  Colors.black ??
                                  Colors.white,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Generated Goals by the App',
                                  style: nutrientValueStyle.copyWith(
                                      fontSize: 16), // Adjust style as needed
                                ),
                                Divider(),
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontSize: 18),
                                    children: [
                                      TextSpan(
                                        text: 'Calories: ',
                                        style: nutrientNameStyle,
                                      ),
                                      TextSpan(
                                        text:
                                            '${calories?.round() ?? 'N/A'} kcal\n',
                                        style: nutrientValueStyle,
                                      ),
                                      TextSpan(
                                        text: 'Proteins: ',
                                        style: nutrientNameStyle,
                                      ),
                                      TextSpan(
                                        text:
                                            '${protein?.round() ?? 'N/A'} g\n',
                                        style: nutrientValueStyle,
                                      ),
                                      TextSpan(
                                        text: 'Carbs: ',
                                        style: nutrientNameStyle,
                                      ),
                                      TextSpan(
                                        text: '${carbs?.round() ?? 'N/A'} g\n',
                                        style: nutrientValueStyle,
                                      ),
                                      TextSpan(
                                        text: 'Fats: ',
                                        style: nutrientNameStyle,
                                      ),
                                      TextSpan(
                                        text: '${fat?.round() ?? 'N/A'} g',
                                        style: nutrientValueStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                  //CARD 2 IMPLEMENTING USING NUTRITION CARD
                  Container(
                    child: FutureBuilder<Map<String, double>>(
                      future: ConsumptionService().fetchDailyConsumptionData(
                        FirebaseAuth.instance.currentUser?.uid ?? '',
                        DateTime.now(), // Current date
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('No nutritional data available');
                        }

                        // Extract current calorie intake from the data
                        double currentCalories =
                            (currentConsumption!.totalCalories) ?? 0;
                        double currentProtein =
                            (currentConsumption!.totalProteins) ?? 0;
                        double currentCarbs =
                            (currentConsumption!.totalCarbs) ?? 0;
                        double currentFats =
                            (currentConsumption!.totalFats) ?? 0;

                        // Assuming 'calories' is your daily calorie goal
                        double calorieGoal =
                            calories ?? 2000; // Default goal if not set

                        // Create the Nutrition Card with the updated data
                        return NutritionCard(
                          nutritionalData: snapshot.data,
                          currentCalories: currentCalories,
                          calories: calorieGoal,
                          protein: currentProtein,
                          carbs: currentCarbs,
                          fat: currentFats,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DailyConsumptionScreenGraph(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10),

                  // CARD 3 'LOG MEAL' BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 120,
                          child: VerticalInfoCard(
                            title: 'Log Food',
                            subtitle: '',
                            info: '',
                            imageUrl: '',
                            cardWidth: 160,
                            iconType: InfoCardIconType.none,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LogFoodConsumption(),
                                ),
                              ).then((_) {
                                fetchCurrentConsumption();
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 20,
                      ),
                      // CARD 3 'NUTRITIONAL PREFERENCES BUTTON
                      Expanded(
                        child: Container(
                          height: 120,
                          child: VerticalInfoCard(
                            title: 'Nutritional \nPreferences',
                            subtitle: '',
                            info: '',
                            imageUrl: '',
                            cardWidth: 160,
                            iconType: InfoCardIconType.none,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const nutritional_preferences(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      drawer: Settings_Drawer(
        onSettingsTap: () {
          // Navigate to settings screen (optional: can implement additional logic if needed)
        },
      ),
    );
  }
}
