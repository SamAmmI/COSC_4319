import 'package:flutter/material.dart';
import 'package:pantree/components/drawer.dart';
import 'package:pantree/models/user_profile.dart';
import 'package:pantree/screens/log_food_screen.dart';
import 'package:pantree/screens/nutritional_preferences.dart';
import 'package:pantree/screens/daily_consumption.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/models/local_user_manager.dart';
import 'package:pantree/components/info_card1.dart';
import 'package:pantree/components/vertical_info_card.dart';

class nutrition_screen extends StatefulWidget {
  const nutrition_screen({Key? key});

  @override
  State<nutrition_screen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<nutrition_screen> {
  String? userEmail;
  UserProfile? userProfile;

  // USER ATTRIBUTES NEEDED FOR THIS SCREEN
  double? calories;
  double? protein;
  double? carbs;
  double? fat;
  String? firstName;

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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${firstName ?? 'User'}", //"Hello, ${userName ?? 'User'}", TO GET THE USERNAME FROM DB
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              "Daily Overview",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            //NEW IMPLEMENTATION USING INFOCARD1
            SingleChildScrollView(
              child: Column(
                children: [
                  // Card 1: User Consumption Details
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
                            builder: (context) =>
                                const DailyConsumptionScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Card 2: Log Meal Button
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 200, // Increased height to avoid overflow
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
                                  builder: (context) => const MealLogScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 200, // Increased height to avoid overflow
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

      drawer: MyDrawer(
        onSignOutTap: () {},
        onFoodInventoryTap: () {},
        onNutritionTap: () {},
        onSettingsTap: () {},
      ),
    );
  }
}
