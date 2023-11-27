import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/auth/login_or_register.dart';
import 'package:pantree/models/food_item.dart';
import 'package:pantree/screens/food_inventory_screen.dart';
import 'package:pantree/screens/initial_registration.dart';
import 'package:pantree/services/foodService.dart'; // Import FoodService to fetch user-specific food items
import 'package:pantree/services/user_service.dart';
import 'package:pantree/models/user_profile.dart';
import 'package:pantree/models/local_user_manager.dart';
import 'package:pantree/screens/logout_screen.dart';
import 'package:pantree/screens/nutrition_screen.dart';
import 'package:pantree/screens/settings_screen.dart';
import 'package:pantree/screens/weight_tracking.dart';
import 'package:pantree/services/foodService.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pantree/screens/recipe_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FoodService foodService = FoodService();
  final UserService userService = UserService();

  // Utilizing a single instance of the user object throuhout the application
  // to reduce the amount of user objects that we create through out the screens
  final LocalUserManager localUser = LocalUserManager();

  @override
  void initState() {
    super.initState();
    checkUserRegistration();
  }

  void _onFoodItemSelected(String foodItem) {
    // Handle the selected food item logic here
    // You can add it to the user's meal, display details, etc.
    // For now, you can print the selected food item.
    print('Selected Food Item: $foodItem');
  }

  PersistentTabController controller = PersistentTabController(initialIndex: 3);
  List<Widget> _buildScreens() {
    return [
      FoodInventoryScreen(
          foodItems: [], onFoodItemSelected: _onFoodItemSelected),
      recipe_screen(),
      nutrition_screen(),
      WeightTrack(),
      settings_screen()
    ];
  }

  List<PersistentBottomNavBarItem> items() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.list),
          title: "Food Inventory",
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.menu_book),
          title: "Recipes",
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.food_bank),
          title: "Nutrition",
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.line_axis),
          title: "Weight Tracking",
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.settings),
          title: "Settings",
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary),
    ];
  }

  // method that will check that the user has all necessary values for application
  bool profileCheck(UserProfile profile) {
    return profile.firstName.isNotEmpty &&
        profile.lastName.isNotEmpty &&
        profile.age != null &&
        profile.height != null &&
        profile.weight != null &&
        (profile.sex == 'M' || profile.sex == 'F');
  }

  Future<bool> checkUserRegistration() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await localUser.fetchAndUpdateUser(firebaseUser.uid);

      //using the local user data
      UserProfile? profile = localUser.getCachedUser();
      return profile != null && profileCheck(profile);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    resizeToAvoidBottomInset: false,
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
