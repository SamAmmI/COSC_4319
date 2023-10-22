import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/components/button.dart';
import 'package:pantree/components/text_field.dart';
import 'package:pantree/screens/second_reg_page.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({
    super.key, 
    required this.onTap
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passTextController = TextEditingController();
  final confirmPassTextController = TextEditingController();
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  
  //signUp() attempts to sign the user in
  //Random comment to make a change to upload to github
  void nextPage() async{
    //Display an error if the passwords do not match
    if(passTextController.text != confirmPassTextController.text){
      Navigator.pop(context);
      showDialog(
        context: context, 
        builder: (context) => const AlertDialog(title: Text("Passwords do not match")));
    }

    try{
      //Creates a new user in the Firestore
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text, 
        password: passTextController.text
        );

        FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential.user!.email)
        .set({
          'email': emailTextController,
          'firstname': firstNameTextController.text,
          'lastname': lastNameTextController.text,
          'password': passTextController.text,
        });
        //If the registration was successful, 
        //then the app proceeds to the next part of registration
        if(context.mounted){
          Navigator.pop(context);
        }
    }on FirebaseAuthException {
      //Display an error if registration fails (Has not been implemented yet)
        
        
    }
  }



  @override
  Widget build(BuildContext context) {
    //Registration page UI
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text("Welcome to Pantree, please create an account", 
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                const SizedBox(height: 10,),
                MyTextField(
                  controller: firstNameTextController, 
                  hintText: "Enter your first name here", 
                  obscureText: false),
                const SizedBox(height: 10,),
                MyTextField(
                  controller: lastNameTextController, 
                  hintText: "Enter your last name here", 
                  obscureText: false),
                const SizedBox(height: 10,),
                MyTextField(
                  controller: emailTextController, 
                  hintText: "Enter Email Here", 
                  obscureText: false),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passTextController, 
                  hintText: "Enter Password Here", 
                  obscureText: true),
                const SizedBox(height: 10),

                MyTextField(
                  controller: confirmPassTextController, 
                  hintText: "Confirm Password Here", 
                  obscureText: true),
                const SizedBox(height: 10,),

                MyButton(
                  onTap: nextPage, 
                  text: "Next"
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text("Sign in Here",
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