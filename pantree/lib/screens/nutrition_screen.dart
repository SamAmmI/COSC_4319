import 'package:flutter/material.dart';
import 'package:pantree/components/drawer.dart';
import 'package:pantree/components/settings_drawer.dart';
import 'package:pantree/models/user_profile.dart';
import 'package:pantree/screens/daily_consumptionBarGraph.dart';
import 'package:pantree/screens/logFoodConsumption.dart';
import 'package:pantree/screens/log_food_screen.dart';
import 'package:pantree/screens/nutritional_preferences.dart';
import 'package:pantree/screens/daily_consumption.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/models/local_user_manager.dart';
import 'package:pantree/components/info_card1.dart';
import 'package:pantree/components/vertical_info_card.dart';
import 'package:pantree/services/user_consumption_service.dart';
import 'package:pie_chart/pie_chart.dart';

class NutritionCard extends StatelessWidget {
  final Map<String, double>? nutritionalData;
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final VoidCallback onTap;

  NutritionCard({
    Key? key,
    this.nutritionalData,
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
        elevation: 4.0,
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
                  child: buildPieChart(nutritionalData!),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Calories Goal: ${calories?.round() ?? 'N/A'}'),
                  Text('Proteins: ${protein?.round() ?? 'N/A'} g'),
                  Text('Carbs: ${carbs?.round() ?? 'N/A'} g'),
                  Text('Fats: ${fat?.round() ?? 'N/A'} g'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPieChart(Map<String, double> data) {
    List<Color> colorList = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red
    ]; // Customize your colors

    double fixedChartRadius = 200;

    return Container(
      width: 300,
      height: 160,
      child: PieChart(
        dataMap: data,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: fixedChartRadius,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 28,
        centerText: "Calories",
        legendOptions: LegendOptions(
          showLegends: false,
          legendPosition: LegendPosition.right,
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
        ),
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
  ConsumptionService? consumptionService;

  // USER ATTRIBUTES NEEDED FOR THIS SCREEN
  double? calories;
  double? protein;
  double? carbs;
  double? fat;
  String? firstName;
  double? caloriesConsumed;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
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
                  Container(
                    width: 400,
                    child: InfoCard(
                      title: 'Calories Goal: ${calories?.round() ?? 'N/A'}',
                      subtitle: 'Proteins: ${protein?.round() ?? 'N/A'}\n'
                          'Carbs: ${carbs?.round() ?? 'N/A'}\n'
                          'Fats: ${fat?.round() ?? 'N/A'}',
                      info: '',
                      imageUrl: '',
                      cardHeight: 180.0,
                      showIcon: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NutriTrack(),
                          ),
                        );
                      },
                    ),
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

                        // CARD 3 CREATE THE NUTRITION CARD WITH THE SAVED DATA
                        return NutritionCard(
                          nutritionalData: snapshot.data,
                          calories: calories,
                          protein: protein,
                          carbs: carbs,
                          fat: fat,
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
                            showIcon: false,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LogFoodConsumption(),
                                ),
                              );
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
                            showIcon: false,
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
