import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/components/button.dart';

class logout extends StatelessWidget {
  const logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Logout Screen"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyButton(
            onTap: (){
              FirebaseAuth.instance.signOut();
            }, 
            text: "Logout"
          )
        ],
      ),
      
    );
  }
}