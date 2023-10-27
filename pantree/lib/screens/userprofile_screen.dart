import 'package:flutter/material.dart';
import 'package:pantree/screens/edit_profile.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(''),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Place Holder',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'placeholder@example.com',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                /*Text(
                  'Bio: Software Developer passionate about mobile app development. Always eager to learn new technologies and improve my coding skills.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),*/

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                                        // Navigate to the EditProfileScreen when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfile())
                    );
                  },
                  child: const Text('Edit Profile'),
               ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}