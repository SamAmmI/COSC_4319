import 'package:flutter/material.dart';
import 'package:pantree/components/drawer.dart';
import 'package:pantree/screens/log_food_screen.dart';
import 'package:pantree/screens/nutritional_preferences.dart';
import 'package:pantree/screens/daily_consumption.dart';
import 'package:firebase_auth/firebase_auth.dart';

class nutrition_screen extends StatefulWidget {
  const nutrition_screen({Key? key});

  @override
  State<nutrition_screen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<nutrition_screen> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    // Fetch user's email from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email?.split('@').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nutrition",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
      ),

      //BELOW IS THE BODY OF THE SCREEN
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${userEmail ?? 'User'}", //"Hello, ${userName ?? 'User'}", TO GET THE USERNAME FROM DB
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              "Daily Overview",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10), // space between overview and card

            // (1) CARD CONTAINING USER CONSUMPTION DETAILS BELOW
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NutriTrack()),
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.yellow,
                child: const Padding(
                  padding: (EdgeInsets.all(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Calories Consumed: 'currentValue'",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("Proteins: consumed/goal"),
                      Text("Carbs: consumed/goal"),
                      Text("Fats: consumed/goal"),
                    ],
                  ),
                ),
              ),
            ),

            // Spacer between card and buttons
            const SizedBox(height: 20),

            // ROW OF BUTTONS THAT WILL LEAD TO 'log_meal' or 'nutritional preferences'
            Row(
              children: [
                // (2) LOG MEAL BUTTON
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MealLogScreen()),
                      );
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          'Log Food',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // (3) NUTRITIONAL PREFERENCES BUTTON
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const nutritional_preferences()),
                      );
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          'Nutritional Preferences',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
