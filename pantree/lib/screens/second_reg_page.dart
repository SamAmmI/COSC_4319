import 'package:flutter/material.dart';
import 'package:pantree/components/button.dart';
import 'package:pantree/components/text_field.dart';
//Contains Height, Current and Goals weights, Gender, and Age

class SecRegPage extends StatefulWidget {
  
  const SecRegPage({
    super.key,
    
  });

  @override
  State<SecRegPage> createState() => _SecRegPageState();
}

class _SecRegPageState extends State<SecRegPage> {
  final heightTextController = TextEditingController();
  final currentWeightController = TextEditingController();
  final goalWeightController = TextEditingController();
  final ageTextController = TextEditingController();
  

  void signIn() async{
    //Add height, current weight, goal weight, age, and gender to firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextField(
                  controller: heightTextController, 
                  hintText: "Enter your height", 
                  obscureText: false
                ),
                MyTextField(
                  controller: currentWeightController, 
                  hintText: "Enter your current body weight here", 
                  obscureText: false
                ),
                MyTextField(
                  controller: goalWeightController, 
                  hintText: "Enter your goal weight here", 
                  obscureText: false
                ),
                MyButton(
                  onTap: signIn, 
                  text: "Register"
                )
              ],
            )
          )
        )
      )
    );
  }
}