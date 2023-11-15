import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantree/auth/auth.dart';
import 'package:pantree/models/user_profile.dart';
import 'package:pantree/models/local_user_manager.dart';

class InitialRegistration extends StatefulWidget {
  const InitialRegistration({super.key});

  @override
  InitialRegistrationState createState() => InitialRegistrationState();
}

class InitialRegistrationState extends State<InitialRegistration> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController goalWeightController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  // Define the options for feet and inches
  List<String> feetOptions = List.generate(
      8, (index) => (index + 1).toString()); // Assuming the range is 1-8 feet
  List<String> inchOptions =
      List.generate(12, (index) => index.toString()); // 0-11 inches

// Controllers for feet and inches
  final feetController = TextEditingController();
  final inchesController = TextEditingController();

  //final UserService userService = UserService();
  final formKey = GlobalKey<FormState>();

  void fetchAndSetUserProfile() async {
    String userID = FirebaseAuth.instance.currentUser?.uid ?? '';

    final localUser = LocalUserManager();
    UserProfile? userProfile = LocalUserManager().getCachedUser();

    // If null will pull from firebase, then save locally
    if (userProfile == null) {
      await localUser.fetchAndUpdateUser(userID);
    }
    // if not not null will set values inputted by user
    if (userProfile != null) {
      setValues(userProfile);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetUserProfile();
  }

  double feetInchesToCm(int feet, int inches) {
    // Constants for conversion
    const double cmPerInch = 2.54;
    const int inchesPerFoot = 12;

    // Convert feet to inches and add the extra inches
    int totalInches = (feet * inchesPerFoot) + inches;

    // Convert inches to centimeters
    double cm = totalInches * cmPerInch;

    return cm;
  }

  setValues(UserProfile userProfile) {
    setState(() {
      firstNameController.text = userProfile.firstName;
      lastNameController.text = userProfile.lastName;
      heightController.text = userProfile.height?.toString() ?? '';
      weightController.text = userProfile.weight?.toString() ?? '';
      ageController.text = userProfile.age?.toString() ?? '';
      goalWeightController.text = userProfile.goalWeight?.toString() ?? '';
      sexController.text = userProfile.sex?.toString() ?? '';
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    goalWeightController.dispose();
    sexController.dispose();
    super.dispose();
  }

  void saveUserProfile() async {
    if (formKey.currentState!.validate()) {}
    String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    final int feet = int.tryParse(feetController.text) ?? 0;
    final int inches = int.tryParse(inchesController.text) ?? 0;

    // Convert the feet and inches to centimeters
    final double heightCm = feetInchesToCm(feet, inches);
    UserProfile userProfile = UserProfile(
      userID: userID,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      height: heightCm,
      weight: double.tryParse(goalWeightController.text),
      age: double.tryParse(ageController.text),
      goalWeight: double.tryParse(goalWeightController.text),
      sex: sexController.text,
    );

    // accessing the localUser
    final localUser = LocalUserManager();
    // Saving the User Profile to the indicated user profile in firebase
    await localUser.userService.setUserProfile(userProfile);

    // saving to the localUser
    localUser.cacheUserData(userProfile);

    // navigating back to 'auth'
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthPage()));
  }

  final List<String> sexOptions = ['M', 'F'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Initial Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildTextFormField(
                  controller: firstNameController,
                  label: 'First Name',
                  validator: (value) => value!.isEmpty ? 'Enter ' : null),
              buildTextFormField(
                  controller: lastNameController,
                  label: 'Last Name',
                  validator: (value) => value!.isEmpty ? 'Enter ' : null),
              DropdownButtonFormField<String>(
                value: feetController.text.isEmpty ? null : feetController.text,
                decoration: InputDecoration(labelText: 'Height (Feet)'),
                items: feetOptions
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    feetController.text = newValue ?? '';
                  });
                },
                validator: (value) =>
                    (value == null || !feetOptions.contains(value))
                        ? 'Select feet'
                        : null,
              ),
              DropdownButtonFormField<String>(
                value: inchesController.text.isEmpty
                    ? null
                    : inchesController.text,
                decoration: InputDecoration(labelText: 'Height (Inches)'),
                items: inchOptions
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    inchesController.text = newValue ?? '';
                  });
                },
                validator: (value) =>
                    (value == null || !inchOptions.contains(value))
                        ? 'Select inches'
                        : null,
              ),
              buildTextFormField(
                  controller: weightController,
                  label: 'Weight',
                  validator: (value) => value!.isEmpty ? 'Enter ' : null),
              buildTextFormField(
                  controller: ageController,
                  label: 'Age',
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter ' : null),
              buildTextFormField(
                  controller: goalWeightController,
                  label: 'Goal Weight',
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter ' : null),
              DropdownButtonFormField<String>(
                value: sexController.text.isEmpty ? null : sexController.text,
                decoration: InputDecoration(labelText: 'Sex'),
                items: sexOptions
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    sexController.text = newValue ?? '';
                  });
                },
                validator: (value) =>
                    (value == null || !sexOptions.contains(value))
                        ? 'Select sex'
                        : null,
              ),
              ElevatedButton(
                onPressed: saveUserProfile,
                child: Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextFormField buildTextFormField({
  required TextEditingController controller,
  required String label,
  TextInputType? keyboardType,
  FormFieldValidator<String>? validator,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: label),
    keyboardType: keyboardType,
    validator: validator,
  );
}
