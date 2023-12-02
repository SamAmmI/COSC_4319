import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pantree/models/user_profile.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pantree/models/local_user_manager.dart';

class nutritional_preferences extends StatefulWidget {
  const nutritional_preferences({super.key});

  @override
  State<nutritional_preferences> createState() =>
      _nutritional_preferencesState();
}

class _nutritional_preferencesState extends State<nutritional_preferences> {
  Map<String, double> data = {"Carbs": 100, "Fats": 50, "Proteins": 120};

  final LocalUserManager userManager = LocalUserManager();

  late double recCarbs = 100;
  late double recFats = 50;
  late double recProtein = 200;
  late double recCalories;
  late double calories;

  void getData() async {
    final currentWeight = await FirebaseFirestore.instance
        .collection("Users")
        .get("Current Weight" as GetOptions?);
    print(currentWeight);
  }

  void calcCalories() {
    calories = 4 * (data["Carbs"]! + data["Proteins"]!) + 9 * data["Fats"]!;
  }

  void setData(double carbs, double proteins, double fats) {
    userManager.updateUserAttribute('Carbs', carbs);
    userManager.updateUserAttribute('Proteins', proteins);
    userManager.updateUserAttribute('Fats', fats);
    setState(() {
      data = {"Carbs": carbs, "Proteins": proteins, "Fats": fats};
      calcCalories();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    UserProfile? userProfile = userManager.getCachedUser();
    if (userProfile != null) {
      recCarbs = userProfile.carbGoal ?? 100;
      recFats = userProfile.fatGoal ?? 50;
      recProtein = userProfile.proteinGoal ?? 120;
      setData(recCarbs, recProtein, recFats);
      calcCalories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Macro-Nutrients",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => showInfoDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PieChart(dataMap: data),
            Text("Carbs: ${data["Carbs"]!.round()}"),
            Slider(
              value: data["Carbs"]!,
              max: 400,
              divisions: 10,
              label: data["Carbs"]!.round().toString(),
              onChanged: (double value) {
                setState(() {
                  data["Carbs"] = value;
                  calcCalories();
                });
              },
            ),
            Text("Protein: ${data["Proteins"]!.round()}"),
            Slider(
              value: data["Proteins"]!,
              max: 400,
              divisions: 10,
              label: data["Proteins"]!.round().toString(),
              onChanged: (double value) {
                setState(() {
                  data["Proteins"] = value;
                  calcCalories();
                });
              },
            ),
            Text("Fats: ${data["Fats"]!.round()}"),
            Slider(
              value: data["Fats"]!,
              max: 200,
              divisions: 10,
              label: data["Fats"]!.round().toString(),
              onChanged: (double value) {
                setState(() {
                  data["Fats"] = value;
                  calcCalories();
                });
              },
            ),
            Text("Allocated Calories for each day: ${calories.round()}"),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
                child: GestureDetector(
                    onTap: () {
                      setData(recCarbs, recProtein, recFats);
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Center(
                            child: Text("Reset",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)))))),
          ],
        ),
      ),
    );
  }

  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Macro Calculations Explained'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your macros are calculated based on:',
                    style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                          text: '• BMR (Basal Metabolic Rate): ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'The number of calories your body needs to perform basic life-sustaining functions. It helps estimate daily calorie needs.'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                          text: '• TDEE (Total Daily Energy Expenditure): ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'Your BMR adjusted for activity level. It represents total calories burned in a day, crucial for setting macro goals.'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                          text: '• Macros Distribution: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'Based on TDEE, carbs, proteins, and fats are proportioned to meet your dietary goals.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
