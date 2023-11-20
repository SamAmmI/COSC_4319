import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/auth/login_or_register.dart';
import 'package:pantree/components/list_tile.dart';
import 'package:pantree/screens/food_inventory_screen.dart';
import 'package:pantree/screens/nutrition_screen.dart';
import 'package:pantree/screens/settings_screen.dart';
import 'package:pantree/screens/recipe_screen.dart';

class MyDrawer extends StatefulWidget {
  final Function()? onSignOutTap;
  final Function()? onNutritionTap;
  final Function()? onFoodInventoryTap;
  final Function()? onSettingsTap;
  final Function()? onRecipesTap;

  const MyDrawer({
    super.key,
    required this.onSignOutTap,
    required this.onNutritionTap,
    required this.onFoodInventoryTap,
    required this.onSettingsTap,
    required this.onRecipesTap,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginOrRegister(
                onTap: () {},
              )));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  void nutritionScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const nutrition_screen()));
  }

  void foodInventory() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FoodInventoryScreen(
                  foodItems: [],
                  onFoodItemSelected: (String foodItem) {},
                )));
  }

  void settingsScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const settings_screen(),
        ));
  }

  void recipeScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => recipe_screen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: MyListTile(
                    icon: Icons.food_bank,
                    text: "Nutrition",
                    onTap: nutritionScreen),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: MyListTile(
                    icon: Icons.list,
                    text: "Food Inventory",
                    onTap: foodInventory),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: MyListTile(
                    icon: Icons.library_books,
                    text: "Recipes",
                    onTap: recipeScreen),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: MyListTile(
                    icon: Icons.settings,
                    text: "Settings",
                    onTap: settingsScreen),
              ),
              MyListTile(icon: Icons.logout, text: "Logout", onTap: signOut)
            ])
          ],
        ));
  }
}
