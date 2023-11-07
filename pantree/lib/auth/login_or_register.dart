import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/components/button.dart';
import 'package:pantree/components/text_field.dart';

class LoginOrRegister extends StatefulWidget {
  final Function()? onTap;

  const LoginOrRegister({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    passTextController.dispose();
    super.dispose();
  }

  void signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passTextController.text,
      );

      // Navigate to the next screen after successful login
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.message}")),
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
                MyTextField(
                  controller: emailTextController,
                  hintText: "Enter email here",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passTextController,
                  hintText: "Enter password here",
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyButton(onTap: signIn, text: "Log In"),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    "Register here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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
