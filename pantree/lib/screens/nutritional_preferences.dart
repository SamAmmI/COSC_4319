/*import 'package:flutter/material.dart';

class nutritional_preferences extends StatelessWidget {
  const nutritional_preferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrional preferences"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Here you can adjust your nutritional preferences"),
      ),
    );
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class nutritional_preferences extends StatefulWidget {
  const nutritional_preferences({super.key});

  @override
  State<nutritional_preferences> createState() => _nutritional_preferencesState();
}

class _nutritional_preferencesState extends State<nutritional_preferences> {

  Map<String, double> data = {
    "Carbs": 100,
    "Fats": 50,
    "Proteins": 120
  };
  
  late double recCarbs = 100;
  late double recFats = 50;
  late double recProtein = 200;
  late double recCalories;
  late double calories;
  
  void getData() async{
    final currentWeight = await FirebaseFirestore.instance.collection("Users").get("Current Weight" as GetOptions?);
    print(currentWeight);
  }
  void calcCalories(){
    calories = 4 * (data["Carbs"]! + data["Proteins"]!) + 9 * data["Fats"]!;
  }

  void setData(double carbs, double proteins, double fats){
    data["Carbs"] = carbs;
    data["Proteins"] = proteins;
    data["Fats"] = fats;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    setData(recCarbs, recProtein, recFats);
    calcCalories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Macro Adjustment Screen"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            
          
          PieChart(
            dataMap: data
          ),
            Text("Carbs: ${data["Carbs"]!.round()}"),
            Slider(
                value: data["Carbs"]!,
                max: 300,
                divisions: 10,
                label: data["Carbs"]!.round().toString(),
                onChanged: (double value){
                  setState(() {
                    data["Carbs"] = value;
                    calcCalories();
                  });
                },
              ),
            Text("Protein: ${data["Proteins"]!.round()}"),
            Slider(
              value: data["Proteins"]!,
              max: 300,
              divisions: 10,
              label: data["Proteins"]!.round().toString(),
              onChanged: (double value){
                setState(() {
                  data["Proteins"] = value;
                  calcCalories();
                });
              },
            ),
            Text("Fats: ${data["Fats"]!.round()}"),
            Slider(
              value: data["Fats"]!,
              max: 150,
              divisions: 10,
              label: data["Fats"]!.round().toString(),
              onChanged: (double value){
                setState(() {
                  data["Fats"] = value;
                  calcCalories();
                });
              },
            ),
            Text("Allocated Calories for each day: $calories"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
              child: GestureDetector(
                onTap: (){
                  setData(recCarbs, recProtein, recFats);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Center(
                    child: Text("Reset", style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ))
                  )
                )
              )
            ),
            
          ],
        ),

        

        ),
        

      );
  }
}