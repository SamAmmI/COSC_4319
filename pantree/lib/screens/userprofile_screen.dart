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

  String getInitials(String fullName) {
    List<String> names = fullName.split(' ');
    if (names.length > 1) {
      return '${names.first.characters.first}${names.last.characters.first}';
    } else {
      return names.first.characters.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    UserProfile? userProfile = _userManager.getCachedUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Display user avatar with initials
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.lightBlue,
                  child: Text(
                    getInitials(
                        '${userProfile?.firstName} ${userProfile?.lastName}'),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display user name and email
                    Text(
                      user != null ? user.displayName ?? '' : 'No User',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5), // Adjust the spacing as needed
                    // Display user profile details
                    _buildUserProfileDetails(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileDetails() {
    UserProfile? userProfile = _userManager.getCachedUser();
    User? user = FirebaseAuth.instance.currentUser;

    if (userProfile != null && user != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display user details (name, height, weight, etc.)
          // Customize this part based on your UserProfile model attributes
          Text(
            '${userProfile.firstName} ${userProfile.lastName}',
            style: const TextStyle(
              fontSize: 20, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user.email ?? 'No Email',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ), // Display user email
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
