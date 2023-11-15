import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/components/modern_text_box.dart';
import 'package:pantree/screens/register_page.dart';
import 'package:pantree/components/selectionButton.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          maintainBottomViewPadding: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // APPLICATION LOGO
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/icons/pantree_logo.png',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 24,
                                  ),
                            ),
                            Text(
                              'Welcome to PanTree',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 20,
                                  ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // BELOW ARE THE TEXT BOXES
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
                  child: Column(
                    children: [
                      ModernTextBox(
                        controller: emailTextController,
                        decoration: InputDecoration(
                          hintText: "Enter email here",
                        ),
                        obscureText: false,
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        width: 350,
                      ),
                      const SizedBox(height: 10),
                      ModernTextBox(
                        controller: passTextController,
                        decoration: InputDecoration(
                          hintText: "Enter password here",
                        ),
                        obscureText: true,
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        width: 350,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    SelectionButton(
                      onPressed: signIn,
                      text: "Log in",
                      width: 200,
                      height: 50,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium ?? TextStyle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SelectionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(
                                onTap: () => Navigator.pop(context),
                              ),
                            ),
                          );
                        },
                        text: "Register here",
                        width: 200,
                        height: 50,
                        textStyle: Theme.of(context).textTheme.bodyMedium ??
                            TextStyle(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
