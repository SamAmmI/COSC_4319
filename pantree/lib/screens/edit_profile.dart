import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pantree/components/modern_text_box.dart';
import 'package:pantree/models/local_user_manager.dart';
import 'package:image_picker/image_picker.dart';

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

  File? _image;
  final picker = ImagePicker();

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
              // Display profile picture and image picker
              _buildProfilePictureSection(),
              const SizedBox(height: 20),
              ModernTextBox(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                width: 350,
              ),
              const SizedBox(height: 20),
              ModernTextBox(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                width: 350,
              ),
              const SizedBox(height: 20),
              ModernTextBox(
                controller: heightController,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                width: 350,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ModernTextBox(
                controller: currentWeightController,
                decoration: const InputDecoration(labelText: 'Current Weight (kg)'),
                width: 350,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ModernTextBox(
                controller: goalWeightController,
                decoration: const InputDecoration(labelText: 'Goal Weight (kg)'),
                keyboardType: TextInputType.number,
                width: 350,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  // Save the edited profile details and image
                  String newFirstName = firstNameController.text;
                  String newLastName = lastNameController.text;
                  double? newHeight = double.tryParse(heightController.text);
                  double? newCurrentWeight =
                      double.tryParse(currentWeightController.text);
                  double? newGoalWeight =
                      double.tryParse(goalWeightController.text);

                  final localUserManager = LocalUserManager();

                  // Update user image
                  if (_image != null) {
                    // Upload the image to storage and get the URL
                    String imageUrl = await uploadImageToStorage(_image!);
                    // Update the user profile with the new image URL
                    await localUserManager.updateUserAttribute(
                        'profilePictureUrl', imageUrl);
                  }

                  // Update other profile details
                  if (newFirstName.isNotEmpty) {
                    await localUserManager.updateUserAttribute(
                        'firstName', newFirstName);
                  }
                  if (newLastName.isNotEmpty) {
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

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        // Display the current profile picture or placeholder
        _image != null
            ? CircleAvatar(
                radius: 60,
                backgroundImage: FileImage(_image!),
              )
            : const CircleAvatar(
                radius: 60,
                // You can set a placeholder image here or leave it empty
              ),
        const SizedBox(height: 10),
        // Button to pick image from gallery
        ElevatedButton(
          onPressed: () async {
            await _getImageFromGallery();
          },
          child: const Text('Image from Gallery'),
        ),
        const SizedBox(height: 10),
        // Button to take a photo using the camera
        ElevatedButton(
          onPressed: () async {
            await _takePhoto();
          },
          child: const Text('Take a Photo'),
        ),
      ],
    );
  }

  Future<void> _getImageFromGallery() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  Future<String> uploadImageToStorage(File image) async {
    // Implement your image upload logic here
    // You can use a storage service or any other method to upload the image
    // and return the URL
    // Example:
    // StorageService storageService = StorageService();
    // String imageUrl = await storageService.uploadImage(image);
    // return imageUrl;

    // For demonstration purposes, return an empty URL
    return '';
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
