import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/components/button.dart';
import 'package:pantree/models/local_user_manager.dart';
import 'package:pantree/models/user_consumption_model.dart';
import 'package:pantree/models/user_profile.dart';
import 'package:pantree/screens/add_food_screen.dart';
import 'package:pantree/screens/logFoodConsumption.dart';
import 'package:pantree/screens/search_food.dart';
import 'package:pantree/services/user_consumption_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NutriTrack extends StatefulWidget {
  const NutriTrack({super.key});

  @override
  State<NutriTrack> createState() => _NutriTrackState();
}

class _NutriTrackState extends State<NutriTrack> {
  UserProfile? userProfile;
  UserConsumption? currentConsumption;
  Map<String, double> eatenMacros = {
    "Carbs": 0.0,
    "Fats": 0.0,
    "Proteins": 0.0
  };
  Map<String, double> allocatedMacros = {
    "Carbs": 100,
    "Fats": 100,
    "Proteins": 100
  };

  late double allocatedCals;
  late double diff;
  @override
  void initState() {
    // TODO: implement initState
    fetchCurrentConsumption();
    fetchUserProfile();

  }

  Future<void> fetchCurrentConsumption() async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    try{
      DateTime currentDate = DateTime.now();
      var consumptionData = await ConsumptionService.instance.getUserConsumptionData(uid, currentDate);
      setState(() {
        if(consumptionData.totalCalories != 0.0){
          eatenMacros["Carbs"] = consumptionData.totalCarbs;
          eatenMacros["Fats"] = consumptionData.totalFats;
          eatenMacros["Proteins"] = consumptionData.totalProteins;
        }
      });
    }catch (e){
      print('Error fetching consumption data: $e');
    }
  }

  void fetchUserProfile() async {
    final localUserManager = LocalUserManager();
    userProfile = localUserManager.getCachedUser();
    if(userProfile == null){
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      await localUserManager.fetchAndUpdateUser(uid);
      userProfile = localUserManager.getCachedUser();
    }

    if(userProfile != null){
      allocatedMacros["Carbs"] = localUserManager.getUserAttribute("Carbs") as double;
      allocatedMacros["Fats"] = localUserManager.getUserAttribute("Fats") as double;
      allocatedMacros["Proteins"] = localUserManager.getUserAttribute("Proteins") as double;
      allocatedCals = localUserManager.getUserAttribute("Calories") as double;
    }
  }

  double getEatenCals() {
    return (eatenMacros["Carbs"]! + eatenMacros["Proteins"]!) * 4 +
        eatenMacros["Fats"]! * 9;
  }

  double getAllocatedCals() {
    return allocatedMacros["Carbs"]! * 4 +
        allocatedMacros["Proteins"]! * 4 +
        allocatedMacros["Fats"]! * 9;
  }

  String remainingMacros(String macro) {
    if (macro == "Calories") {
      diff = (getAllocatedCals() - getEatenCals());
    } else {
      diff = (allocatedMacros[macro]! - eatenMacros[macro]!);
    }

    if (diff >= 0) {
      return "$macro: $diff $macro Remaining";
    } else {
      return "$macro: ${diff.abs()} $macro Over Allocated";
    }
  }

  void newFood() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchFood(
                  userId: '',
                )));
  }

  double getPercent(String macro) {
    double percent;
    if (macro != "Calories") {
      percent = eatenMacros[macro]! / allocatedMacros[macro]!;
    } else {
      percent = getEatenCals() / getAllocatedCals();
    }

    if (percent > 1) {
      return 1;
    } else {
      return percent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Daily Nutrition Tracking",
            style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pop(); // Add this line to perform back navigation
          },
        ),
      ),
      body: Column(children: [
        PieChart(dataMap: eatenMacros),
        Text(remainingMacros("Carbs")),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          LinearPercentIndicator(
            width: 300,
            lineHeight: 20,
            percent: getPercent("Carbs"),
            backgroundColor: Colors.red[100],
          ),
        ]),
        const SizedBox(
          height: 5,
        ),
        Text(remainingMacros("Proteins")),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          LinearPercentIndicator(
            width: 300,
            lineHeight: 20,
            percent: getPercent("Proteins"),
            backgroundColor: Colors.green[100],
            progressColor: Colors.green,
          ),
        ]),
        const SizedBox(
          height: 5,
        ),
        Text(remainingMacros("Fats")),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          LinearPercentIndicator(
              width: 300,
              lineHeight: 20,
              percent: getPercent("Fats"),
              backgroundColor: Colors.blue[100],
              progressColor: Colors.blue),
        ]),
        const SizedBox(
          height: 5,
        ),
        Text(remainingMacros("Calories")),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          LinearPercentIndicator(
              width: 300,
              lineHeight: 20,
              percent: getPercent("Calories"),
              backgroundColor: Colors.grey[300],
              progressColor: Colors.black),
        ]),
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
            child: MyButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                      const LogFoodConsumption(),
                  ),
                );
              }, 
              text: "Log New Food"
            )
        )
      ]),
    );
  }
}
