import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/screens/edit_profile.dart';
import 'package:pantree/models/user_profile.dart';
import 'package:pantree/models/local_user_manager.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final LocalUserManager _userManager = LocalUserManager.userInstance;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                // Display user avatar
                const CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      AssetImage(''), // Add your image asset path here
                ),
                const SizedBox(height: 20),
                // Display user email
                Text(
                  user != null ? user.email ?? 'No Email' : 'No User',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                // Display user profile details
                _buildUserProfileDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileDetails() {
    UserProfile? userProfile = _userManager.getCachedUser();

    if (userProfile != null) {
      return Column(
        children: [
          // Display user details (name, height, weight, etc.)
          // Customize this part based on your UserProfile model attributes
          Text('Name: ${userProfile.firstName} ${userProfile.lastName}'),
          Text('Height: ${userProfile.height} m'),
          Text('Weight: ${userProfile.weight} kg'),
          // Add more attributes as needed

          const SizedBox(height: 20),
          // Display edit profile button
          ElevatedButton(
            onPressed: () {
              _editProfile(context);
            },
            child: const Text('Edit Profile'),
          ),
        ],
      );
    } else {
      return const Text('Loading...'); // Add a loading indicator if necessary
    }
  }

  void _editProfile(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfile()),
    );

    // Refresh the user profile details after editing
    setState(() {});
  }
}
