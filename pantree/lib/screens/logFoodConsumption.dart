import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/models/local_user_manager.dart';
import 'package:pantree/models/user_profile.dart';
import 'package:pantree/screens/searchFoodToConsume.dart';
import 'package:pantree/services/user_consumption_service.dart';

class LogFoodConsumption extends StatefulWidget {
  const LogFoodConsumption({Key? key}) : super(key: key);

  @override
  _LogFoodConsumptionState createState() => _LogFoodConsumptionState();
}

class _LogFoodConsumptionState extends State<LogFoodConsumption> {
  final ConsumptionService consumptionService = ConsumptionService.instance;
  UserProfile? userProfile;

  List<DocumentSnapshot> foodInventory =
      []; // List to hold food inventory items

  // USER ATTRIBUTES NEEDED FOR THIS SCREEN
  double? calories;
  double? protein;
  double? carbs;
  double? fat;
  String? firstName;

  void logMeal(DocumentSnapshot foodItemDoc, double consumedQuantity) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DateTime date = DateTime.now();
      bool fromInventory = true;

      // Log consumption and update totals
      await consumptionService.logConsumptionAndUpdateTotals(
        userId,
        date,
        foodItemDoc,
        fromInventory,
        consumedQuantity,
      );

      // Update the Firestore document for the consumed item
      await foodItemDoc.reference.update(
          {'quantity': FieldValue.increment(-consumedQuantity)}).then((_) {
        // Fetch updated inventory after confirming Firestore update
        fetchFoodInventory(); // Just call without await
      }).catchError((error) {
        print('Error updating Firestore: $error');
      });

      // Showing a confirmation SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Logged '${foodItemDoc['label']}' to your consumption log."),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (error) {
      print('Error logging meal: $error');
    }
  }

  void fetchFoodInventory() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('foodItems')
        .get()
        .then((snapshot) {
      setState(() {
        foodInventory = snapshot.docs
          ..sort((a, b) => (a.data())['label'].compareTo((b.data())['label']));
      });
    });
  }

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
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchFoodInventory(); // Fetch food inventory on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log Meal"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchFoodToConsume(
                    userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                    onFoodItemSelected: (foodItemDoc) {
                      logMeal(foodItemDoc as DocumentSnapshot,
                          1.0); // Assuming 1.0 as consumed quantity for simplicity
                    },
                  ),
                ),
              );
            },
            child: Text("Search Food Item"),
          ),
          // WHERE THE INVENTORY LIST IS DISPLAYED TO THE USER
          Expanded(
            child: ListView.builder(
              itemCount: foodInventory.length,
              itemBuilder: (context, index) {
                DocumentSnapshot foodItemDoc = foodInventory[index];
                var foodData = foodItemDoc.data() as Map<String, dynamic>;
                return ListTile(
                  leading: foodData['image'] != null
                      ? Image.network(foodData['image'],
                          width: 100, height: 100, fit: BoxFit.cover)
                      : null, // Show an image if the URL exists
                  title: Text(foodData['label'] ?? 'No Name'),
                  subtitle: Text('Quantity: ${foodData['quantity']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      // Prompt user for consumption quantity
                      showDialog(
                        context: context,
                        builder: (context) {
                          final TextEditingController _controller =
                              TextEditingController();
                          return AlertDialog(
                            title: Text('Log Consumption'),
                            content: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                labelText: 'Enter quantity consumed',
                                hintText: 'e.g., 1',
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Log'),
                                onPressed: () {
                                  double? consumedQuantity =
                                      double.tryParse(_controller.text);
                                  if (consumedQuantity != null &&
                                      consumedQuantity > 0) {
                                    logMeal(foodItemDoc, consumedQuantity);
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // USER GOAL NUTRIENTS DISPLAY
          if (calories != null &&
              protein != null &&
              carbs != null &&
              fat != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Nutritional Information:\n',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Calories: ${calories?.toStringAsFixed(0)} kcal\n',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: 'Protein: ${protein?.toStringAsFixed(2)} g\n',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: 'Carbs: ${carbs?.toStringAsFixed(2)} g\n',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: 'Fat: ${fat?.toStringAsFixed(2)} g',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
