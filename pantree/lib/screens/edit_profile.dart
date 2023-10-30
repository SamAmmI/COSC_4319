import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController currentWeightController = TextEditingController();
  TextEditingController goalWeightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: heightController,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: currentWeightController,
                decoration: InputDecoration(labelText: 'Current Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: goalWeightController,
                decoration: InputDecoration(labelText: 'Goal Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Save the edited profile details
                  String newName = nameController.text;
                  String newEmail = emailController.text;
                  double newHeight =
                      double.tryParse(heightController.text) ?? 0.0;
                  double newCurrentWeight =
                      double.tryParse(currentWeightController.text) ?? 0.0;
                  double newGoalWeight =
                      double.tryParse(goalWeightController.text) ?? 0.0;

                  // Here you can update the user's profile information in your database.
                  // For demonstration purposes, print the updated details.
                  print('Updated Name: $newName');
                  print('Updated Email: $newEmail');
                  print('Updated Height: $newHeight cm');
                  print('Updated Current Weight: $newCurrentWeight kg');
                  print('Updated Goal Weight: $newGoalWeight kg');

                  // Navigate back to the user profile screen after saving the changes.
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
    heightController.dispose();
    currentWeightController.dispose();
    goalWeightController.dispose();
    super.dispose();
  }
}
