import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pantree/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passTextController = TextEditingController();
  final confirmPassTextController = TextEditingController();
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();

  void nextPage() async {
    RegExp reg =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!reg.hasMatch(passTextController.text)) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
              title: Text("Please Enter Valid Password"),
              content: Text(
                  "Passwords must contain:\nAt least one capital letter\nAt least one lowercase letter\nAt least one number\nAt least one special character\nAt least 8 characters long")));
    }
    if (passTextController.text != confirmPassTextController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passTextController.text,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        'email': emailTextController.text,
        'firstname': firstNameTextController.text,
        'lastname': lastNameTextController.text,
      });

      Navigator.pop(context); // Navigate to the next screen
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: ${e.message}")),
      );
    }
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
                Text("Welcome to Pantree, please create an account",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: firstNameTextController,
                    hintText: "Enter your first name here",
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: lastNameTextController,
                    hintText: "Enter your last name here",
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
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
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: nextPage,
                    child: Text("Next"),
                    style: ElevatedButton.styleFrom(enableFeedback: true)),
                ElevatedButton(
                  onPressed: widget.onTap,
                  child: const Text(
                    "Sign in Here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
