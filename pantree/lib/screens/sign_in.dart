import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({
    super.key, 
    required this.onTap,
    });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passTextController = TextEditingController();
  //Handles user login
  void signIn() async{
    try{
      //Checks if there is a user with the info that the user inputted
      //If successful then will proceed to the next page
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text, 
        password: passTextController.text
      );
    } on FirebaseAuthException {
      //If login failed, then an error message will display
      //(Has not been implemented yet)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                const Text("Welcome back to Pantree, please sign in", 
                style: TextStyle(color: Colors.white)),
                const SizedBox(height: 10,),
                MyTextField(
                  controller: emailTextController, 
                  hintText: "Enter email here", 
                  obscureText: false),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passTextController, 
                  hintText: "Enter password here", 
                  obscureText: true),
                const SizedBox(height: 10),

                MyButton(
                  onTap: signIn, 
                  text: "Log In"
                ),
                const SizedBox(height: 4),

                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text("Register here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue
                      )
                  )
                )

              ]
            )
          )
        )
      )
    );
  }
}