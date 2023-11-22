import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pantree/models/food_item.dart';
import 'package:pantree/services/foodService.dart';

class ConsumptionService {
  static final ConsumptionService instance = ConsumptionService._internal();
  final FirebaseFirestore _firestore;
  final FoodService foodService = FoodService();

  // FACTORY CONSTRUCTOR
  factory ConsumptionService() {
    return instance;
  }

  // CONSTRUCTOR USING THE SINGLETON METHOD
  ConsumptionService._internal() : _firestore = FirebaseFirestore.instance;

  CollectionReference get userConsumption =>
      _firestore.collection('userConsumption');

  // METHOD TO LOG CONSUMPTION TO USER AND UPDATE THEIR DAILY INTAKE
  Future<void> logConsumptionAndUpdateTotals(String userId, DateTime date,
      DocumentSnapshot foodItemDoc, bool fromInventory, double quantity) async {
    String dateStr = "${date.year}-${date.month}-${date.day}";
    // Get references without specifying type parameters
    DocumentReference userLog =
        userConsumption.doc(userId).collection(dateStr).doc();
    DocumentReference dailyTotalsDoc =
        userConsumption.doc(userId).collection(dateStr).doc('dailyTotals');

    // Extract the nutrients data by casting the snapshot data
    Map<String, dynamic>? foodItemData =
        foodItemDoc.data() as Map<String, dynamic>?;
    Map<String, dynamic>? nutrients =
        foodItemData?['nutrients'] as Map<String, dynamic>?;

    if (nutrients == null) {
      throw Exception(
          'Nutritional information is missing for food item ${foodItemDoc.id}');
    }

    // Prepare the consumed item data
    Map<String, dynamic> consumedItemData = {
      'foodItemId': foodItemDoc.id,
      'fromInventory': fromInventory,
      'quantity': quantity,
      'time': Timestamp.fromDate(DateTime.now()),
    };

    await userLog.set(consumedItemData);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot dailyTotalsSnapshot =
          await transaction.get(dailyTotalsDoc);

      // Cast the snapshot data to the correct type
      Map<String, dynamic>? dailyTotalsData =
          dailyTotalsSnapshot.data() as Map<String, dynamic>?;

      // Calculate new totals
      double totalCalories =
          dailyTotalsData?['totalCalories']?.toDouble() ?? 0.0;
      double totalCarbs = dailyTotalsData?['totalCarbs']?.toDouble() ?? 0.0;
      double totalFat = dailyTotalsData?['totalFat']?.toDouble() ?? 0.0;
      double totalProtein = dailyTotalsData?['totalProtein']?.toDouble() ?? 0.0;

      totalCalories += (nutrients['ENERC_KCAL']?.toDouble() ?? 0) * quantity;
      totalCarbs += (nutrients['CHOCDF']?.toDouble() ?? 0) * quantity;
      totalFat += (nutrients['FAT']?.toDouble() ?? 0) * quantity;
      totalProtein += (nutrients['PROCNT']?.toDouble() ?? 0) * quantity;

      // Update the totals in Firestore within the transaction
      transaction.set(
          dailyTotalsDoc,
          {
            'totalCalories': totalCalories,
            'totalCarbs': totalCarbs,
            'totalFat': totalFat,
            'totalProtein': totalProtein,
          },
          SetOptions(merge: true));
    });

    // If the item is from inventory, reduce its quantity
    if (fromInventory) {
      for (int i = 0; i < quantity; i++) {
        await foodService.consumedFoodItem(foodItemDoc.id, userId, 1);
      }
    }
  }

  // METHOD TO REMOVE LOGGED FOOD ITEM AND HANDLE INVENTORY
  Future<void> removeLoggedFoodItem(String userId, DateTime date, String logId,
      bool fromInventory, String foodId, double quantity) async {
    String dateStr = "${date.year}-${date.month}-${date.day}";
    DocumentReference logRef =
        userConsumption.doc(userId).collection(dateStr).doc(logId);
    DocumentReference dailyTotalsDoc =
        userConsumption.doc(userId).collection(dateStr).doc('dailyTotals');

    // Retrieve the food item details from Firestore using foodId
    DocumentSnapshot foodItemSnapshot =
        await _firestore.collection('foodItems').doc(foodId).get();
    Map<String, dynamic>? foodItemData =
        foodItemSnapshot.data() as Map<String, dynamic>?;
    Map<String, dynamic>? nutrients =
        foodItemData?['nutrients'] as Map<String, dynamic>?;

    if (nutrients == null) {
      throw Exception(
          'Nutritional information is missing for food item $foodId');
    }

    // Delete the log entry
    await logRef.delete();

    // Recalculate daily totals
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot dailyTotalsSnapshot =
          await transaction.get(dailyTotalsDoc);

      // Calculate new totals
      double totalCalories =
          dailyTotalsSnapshot['totalCalories']?.toDouble() ?? 0.0;
      double totalCarbs = dailyTotalsSnapshot['totalCarbs']?.toDouble() ?? 0.0;
      double totalFat = dailyTotalsSnapshot['totalFat']?.toDouble() ?? 0.0;
      double totalProtein =
          dailyTotalsSnapshot['totalProtein']?.toDouble() ?? 0.0;

      totalCalories -= (nutrients['ENERC_KCAL']?.toDouble() ?? 0) * quantity;
      totalCarbs -= (nutrients['CHOCDF']?.toDouble() ?? 0) * quantity;
      totalFat -= (nutrients['FAT']?.toDouble() ?? 0) * quantity;
      totalProtein -= (nutrients['PROCNT']?.toDouble() ?? 0) * quantity;

      // Update the totals in Firestore
      transaction.set(
          dailyTotalsDoc,
          {
            'totalCalories': totalCalories,
            'totalCarbs': totalCarbs,
            'totalFat': totalFat,
            'totalProtein': totalProtein,
          },
          SetOptions(merge: true));
    });

    // If the item was from inventory, add it back if necessary
    if (fromInventory) {
      // Loop to add the item back to inventory based on quantity
      for (int i = 0; i < quantity; i++) {
        await foodService.addFoodItemToUserDatabase(
            userId, foodService.searchOrAddFood(foodId) as FoodItem, 1);
      }
    }
  }

  // METHOD TO FETCH DAILY CONSUMPTIN DATA
  Future<Map<String, double>> fetchDailyConsumptionData(
      String userId, DateTime date) async {
    String dateStr = "${date.year}-${date.month}-${date.day}";
    DocumentSnapshot dailyTotalsSnapshot = await userConsumption
        .doc(userId)
        .collection(dateStr)
        .doc('dailyTotals')
        .get();

    Map<String, dynamic>? data =
        dailyTotalsSnapshot.data() as Map<String, dynamic>?;

    return {
      'calories': data?['calories']?.toDouble() ?? 0.0,
      'proteins': data?['proteins']?.toDouble() ?? 0.0,
      'carbs': data?['carbs']?.toDouble() ?? 0.0,
      'fats': data?['fats']?.toDouble() ?? 0.0,
    };
  }

  // METHOD TO FETCH WEEKLY CONSUMPTION DATA
  Future<List<Map<String, double>>> fetchWeeklyConsumptionData(
      String userId, DateTime startDate) async {
    List<Map<String, double>> weeklyData = [];

    for (int i = 0; i < 7; i++) {
      DateTime date = startDate.add(Duration(days: i));
      Map<String, double> dailyData =
          await fetchDailyConsumptionData(userId, date);
      weeklyData.add(dailyData);
    }

    return weeklyData;
  }
}
