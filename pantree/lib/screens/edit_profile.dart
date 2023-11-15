import 'package:flutter/material.dart';
import 'package:pantree/components/modern_text_box.dart';
import 'package:pantree/models/local_user_manager.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
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
              ModernTextBox(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                width: 350,
              ),
              const SizedBox(height: 20),
              ModernTextBox(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                width: 350,
              ),
              const SizedBox(height: 20),
              ModernTextBox(
                controller: heightController,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                width: 350,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ModernTextBox(
                controller: currentWeightController,
                decoration: InputDecoration(labelText: 'Current Weight (kg)'),
                width: 350,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ModernTextBox(
                controller: goalWeightController,
                decoration: InputDecoration(labelText: 'Goal Weight (kg)'),
                keyboardType: TextInputType.number,
                width: 350,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  // Save the edited profile details
                  String newFirstName = firstNameController.text;
                  String newLastName = lastNameController.text;
                  double? newHeight = double.tryParse(heightController.text);
                  double? newCurrentWeight =
                      double.tryParse(currentWeightController.text);
                  double? newGoalWeight =
                      double.tryParse(goalWeightController.text);

                  final localUserManager = LocalUserManager();

                  //UPDATING USER PROFILE SETTING
                  if (newFirstName.isNotEmpty) {
                    await localUserManager.updateUserAttribute(
                        'firstName', newFirstName);
                  }
                  if (newFirstName.isNotEmpty) {
                    await localUserManager.updateUserAttribute(
                        'lastName', newLastName);
                  }
                  if (newHeight != null) {
                    await localUserManager.updateUserAttribute(
                        'height', newHeight);
                  }
                  if (newCurrentWeight != null) {
                    await localUserManager.updateUserAttribute(
                        'currentWeight', newCurrentWeight);
                  }
                  if (newGoalWeight != null) {
                    await localUserManager.updateUserAttribute(
                        'goalWeight', newGoalWeight);
                  }

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
    firstNameController.dispose();
    lastNameController.dispose();
    heightController.dispose();
    currentWeightController.dispose();
    goalWeightController.dispose();
    super.dispose();
  }
}
