import 'package:flutter/material.dart';
import 'package:pantree/components/drawer.dart';

class nutrition_screen extends StatefulWidget {
  const nutrition_screen({super.key});

  @override
  State<nutrition_screen> createState() => _nutrition_screenState();
}

class _nutrition_screenState extends State<nutrition_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nutrition",
        style: TextStyle(color: Theme.of(context).colorScheme.primary)
        ),
        centerTitle: true,
      ),

      //BELOW IS THE BODY OF THE SCREEN
      body: Padding(
        padding:const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, ", //"Hello, ${userName ?? 'User'}", TO GET THE USERNAME LATER
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Text("Daily Overview",
              style:TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            
            Card(
              elevation: 2,
              child: Padding(
                padding: (const EdgeInsets.all(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Calories Consumed: consumed/goal"), // You can replace placeholder with actual data.
                    Text("Proteins: consumed/goal"),
                    Text("Carbs: consumed/goal"),
                    Text("Fats: consumed/goal"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      
      drawer: MyDrawer(
        onSignOutTap: (){},
        onFoodInventoryTap: (){},
        onNutritionTap: (){},
        onSettingsTap: (){},
      ),
    );
  }
}
