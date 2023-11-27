import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pantree/components/recipe_view.dart';
import 'package:pantree/components/settings_drawer.dart';
import 'package:pantree/models/recipe_models.dart';
import 'package:url_launcher/url_launcher.dart';

class recipe_screen extends StatefulWidget {
  @override
  _recipeScreenState createState() => _recipeScreenState();
}

class _recipeScreenState extends State<recipe_screen> {
  List<RecipeModel> recipes = <RecipeModel>[];

  String applicationId = "c25df61e";
  String applicationKey = "eaf1f2fc95e4c096ab81c799330e585b";

  Future<void> getRecipes() async {
  // Get the current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    // Get foodItems collection for the current user
    CollectionReference foodItemsRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('foodItems');

    // Get all foodItem documents
    QuerySnapshot foodItemsSnapshot = await foodItemsRef.get();
    List<QueryDocumentSnapshot> allFoodItems = foodItemsSnapshot.docs;

    for (QueryDocumentSnapshot foodItem in allFoodItems) {
      // Get label field from each foodItem document
      String label = foodItem.get('label');

      String url =
          "https://api.edamam.com/search?q=$label&app_id=$applicationId&app_key=$applicationKey";

      var response = await http.get(Uri.parse(url));
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      jsonData["hits"].forEach((element) {
        print(element.toString());

        RecipeModel recipeModel = RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipes.add(recipeModel);
      });

      print("${recipes.toString()}");
      print(label);
    }
  }
}
  Future<void> getRecipesTogether() async {
  // Get the current user
  // Get the current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    // Get foodItems collection for the current user
    CollectionReference foodItemsRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('foodItems');

    // Get all foodItem documents
    QuerySnapshot foodItemsSnapshot = await foodItemsRef.get();
    List<QueryDocumentSnapshot> allFoodItems = foodItemsSnapshot.docs;

    // Save all foodItems into one string separated by commas
    List<String> labels = [];
    for (QueryDocumentSnapshot foodItem in allFoodItems) {
      // Get label field from each foodItem document
      String label = foodItem.get('label');
      labels.add(label);
    }
    String labelsString = labels.join(',');

    String url =
        "https://api.edamam.com/search?q=$labelsString&app_id=$applicationId&app_key=$applicationKey";

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element) {
      print(element.toString());

      RecipeModel recipeModel = RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);
    });

    print("${recipes.toString()}");
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Recipes",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
        ),
        drawer: Settings_Drawer(
          onSettingsTap: () {
            // Navigate to settings screen (optional: can implement additional logic if needed)
          },
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: kIsWeb
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: <Widget>[
                        Text("PanTree ",
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(
                          "Recipes Search",
                          style: Theme.of(context).textTheme.titleLarge
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Click the search icons below for suggested recipes",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: () {
                                setState(() {
                                  getRecipes();
                                });
                            },
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                Icon(
                                  Icons.search,
                                ),
                                SizedBox(width: 1), // You can adjust this value as needed
                              Text(
                              'Individual Search',
                              style: Theme.of(context).textTheme.bodyMedium
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                                setState(() {
                                  getRecipesTogether();
                                });
                            },
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                Icon(
                                  Icons.search,
                                ),
                                SizedBox(width: 1), // You can adjust this value as needed
                              Text(
                              'Grouped Search',
                              style: Theme.of(context).textTheme.bodyMedium
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                          InkWell(
                            onTap:() {
                              setState(() {
                                recipes.clear();
                              });
                            },
                            child: Container(
                              child: Icon(
                                Icons.refresh,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: GridView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 50.0,
                        ),
                        children: List.generate(recipes.length, (index) {
                          return GridTile(
                            child: RecipieTile(
                              title: recipes[index].label,
                              desc: recipes[index].source,
                              imgUrl: recipes[index].image,
                              url: recipes[index].url,
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
 }
}

class RecipieTile extends StatefulWidget {
  final String? title, desc, imgUrl, url;

  RecipieTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String? url) async {
    print(url);
    if (await canLaunchUrl(Uri.parse(url!))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                            postUrl: widget.url,
                          )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title!,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontFamily: 'Schyler',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.desc!,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Trajan Pro'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
