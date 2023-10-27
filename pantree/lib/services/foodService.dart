import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pantree/models/food_item.dart';

/*
API service document that will allows us to retrive food nutrients details from 
api and other details such as image and others.

hope to still work on this and 'food_item.dart' for easier retrieval of data 
in the future and provide better abstraction for the application

***(10/27/23) 
  - converted into class document to allow for methods to retrieve food information easier 
    through this class from our database or api - johnny

CLASS METHODS BELOW
-------------------
'addFoodItemToFirebase()' , when item not in database it will add it 

'searchOrAddFood()' , first it searches database, if not found contact api

'fetchFoodImage()' , given the foodId, it will return the url to the image in the database

*/
class FoodService {

final CollectionReference foodItems = FirebaseFirestore.instance.collection('foodItems');

// method to add food item for firsbase
Future<FoodItem> addFoodItemToFirebase(FoodItem food) async {

  await foodItems.doc(food.foodId).set(food.toMap());

  // Removed the subcollection so that it reduces server contact
  // able to store nutrients within the foodItem entirely
  // await docRef.collection('nutrients').add(food.nutrients); 

  return food;
}

// first we want to search database if !exist we then turn to the api 
// to search and after search we add to database so that next search 
// we dont have to request from Api again
Future<FoodItem?> searchOrAddFood(String foodName) async {

  // Required Api info, my Id and appKey
  const String apiURL = 'https://api.edamam.com/api/food-database/v2/parser';
  const String appId = 'f11d8162';
  const String appKey = 'e271a11e5e0db5ab9860827c0713bda1';

  //search in Database aka Firebase
  final QuerySnapshot snapshot = await foodItems.where('label', isEqualTo: foodName).get();

  // check cases to see if database connected and not empty
  // then will check if 'label' exists in the Firebase
  if(snapshot.docs.isNotEmpty) {

    // FOUND IN FIREBASE
    final doc = snapshot.docs.first;
    return FoodItem.fromMap(doc.data() as Map<String, dynamic>);
  }

  // if not in Firebase, fetch from API
  final response = await http.get(Uri.parse('$apiURL?app_id=$appId&app_key=$appKey&ingr=$foodName&nutrition-type=logging'));

  // if response code '200' means response from api
  if(response.statusCode == 200){
    
    final parsedResponse = json.decode(response.body);

    if(parsedResponse['parsed'] != null && parsedResponse['parsed'].length > 0){

      final foodData = parsedResponse['parsed'][0]['food'];

      // consturcting the FoodItem object
      final food = FoodItem(
        foodId: foodData['foodId'],
        label: foodData['label'],
        knownAs: foodData['knownAs'],
        nutrients: foodData['nutrients'],
        category: foodData['category'],
        categoryLabel: foodData['categoryLabel'],
        image: foodData['image'],
      );

      // now add the new object into Firebase to have stored for next search
      await addFoodItemToFirebase(food);

      // returned the fetched foodItem from api
      return food;
    }
  } else {
    throw Exception('failed to fetch food data');
  }
  return null;
}

Future<String?> fetchFoodImageLink(String foodId) async {
   
   DocumentSnapshot doc = await foodItems.doc(foodId).get();

  if(doc.data() != null){
    Map<String, dynamic> data  = doc.data() as Map<String, dynamic>;
    return data['image'];
  }
  return null;
  }

}
