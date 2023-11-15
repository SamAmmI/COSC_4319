import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/auth/login_or_register.dart';
import 'package:pantree/models/food_item.dart';
import 'package:pantree/screens/food_inventory_screen.dart';
import 'package:pantree/screens/logout_screen.dart';
import 'package:pantree/screens/nutrition_screen.dart';
import 'package:pantree/screens/settings_screen.dart';
import 'package:pantree/services/foodService.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart'; // Import FoodService to fetch user-specific food items

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FoodService foodService = FoodService();

  void _onFoodItemSelected(String foodItem) {
    // Handle the selected food item logic here
    // You can add it to the user's meal, display details, etc.
    // For now, you can print the selected food item.
    print('Selected Food Item: $foodItem');
  }

  PersistentTabController controller = PersistentTabController(initialIndex: 0);
  List<Widget> _buildScreens(){
    return[
      FoodInventoryScreen(
        foodItems: [], 
        onFoodItemSelected: _onFoodItemSelected
      ),
      nutrition_screen(),
      settings_screen(),
      logout()
    ];
  }

  List<PersistentBottomNavBarItem> items(){
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.list),
          title: "Food Inventory",
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.food_bank),
          title: "Nutrition",
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.settings),
          title: "Settings",
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.logout),
          title: "Logout",
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary
        ),
      ];
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<List<FoodItem>>(
              future: foodService
                  .getUserFoodItems(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, foodItemsSnapshot) {
                if (foodItemsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (foodItemsSnapshot.hasError) {
                  return Center(child: Text('Error fetching food items'));
                } else {
                  return PersistentTabView(
                    context, 
                    controller: controller,
                    screens: _buildScreens(),
                    items: items(),
                    confineInSafeArea: true,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    handleAndroidBackButtonPress: true,
                    resizeToAvoidBottomInset: true,
                    stateManagement: true,
                    hideNavigationBarWhenKeyboardShows: true,
                    popAllScreensOnTapOfSelectedTab: true,
                    popActionScreens: PopActionScreensType.all,
                    navBarStyle: NavBarStyle.style1,
                  );
                }
              },
            );
          } else {
            return LoginOrRegister(onTap: () {});
          }
        },
      ),
    );
  }
}
