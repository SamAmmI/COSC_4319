import 'dart:convert';
import 'dart:io';
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
  TextEditingController textEditingController = TextEditingController();

  String applicationId = "c25df61e";
  String applicationKey = "eaf1f2fc95e4c096ab81c799330e585b";

  getRecipes(String query) async {
    //query here is the main thing you change to get different food, but when you search it doesn't delete your last searched entry.
    String url =
        "https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey";

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element) {
      print(element.toString());

      RecipeModel recipeModel = RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);
    });

    setState(() {});
    print("${recipes.toString()}");
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
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 33, 80, 45),
                Color.fromARGB(255, 18, 63, 42),
              ])),
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
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Text(
                          "Recipes Search",
                          style: TextStyle(
                              color: Color.fromARGB(255, 20, 155, 15),
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Enter Your Ingredients Below",
                      style: TextStyle(fontSize: 20, color: Colors.white),
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
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              decoration: InputDecoration(
                                  hintText: "Enter Ingredients",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.5),
                                  )),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: () {
                              if (textEditingController.text.isNotEmpty) {
                                getRecipes(textEditingController.text);
                              }
                            },
                            child: Container(
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
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
