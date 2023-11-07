import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/auth/login_or_register.dart';
import 'package:pantree/screens/food_inventory_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If user signs in successfully then they go to the FoodInventoryScreen
            return FoodInventoryScreen(foodItems: []);
          } else {
            // If the user fails to sign in then they stay on the current page
            return LoginOrRegister(onTap: () {});
          }
        },
      ),
    );
  }
}
