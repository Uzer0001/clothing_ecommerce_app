import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _profileImageUrl;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    try {
      print('Fetching user data for email: ${currentUser!.email}');
      
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUser!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;

        print('User data found: ${userDoc.data()}');
        
        setState(() {
          _nameController.text = userDoc.get('userName') ?? ''; // Load username
          _profileImageUrl = userDoc.get('profileImage') ?? ''; // Load profile image
        });
      } else {
        print("No user data found for email: ${currentUser!.email}");
      }
    } catch (e) {
      print("Failed to load user data: $e");
    }
  }

  
Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);

    // Show loading while uploading image
    EasyLoading.show(status: 'Uploading Image...');

    // Upload the image to Firebase Storage
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profileImages/${currentUser!.email}.jpg'); // Store with user's email

      // Upload the file to Firebase Storage
      await storageRef.putFile(imageFile);

      // Get the download URL for the uploaded file
      String downloadUrl = await storageRef.getDownloadURL();

      // Update the state with the new image URL
      setState(() {
        _profileImageUrl = downloadUrl; // Set download URL from Firebase Storage
      });

      EasyLoading.dismiss();

      Get.snackbar(
        "Image Uploaded",
        "Profile image updated successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        "Failed to upload image: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

Future<void> _saveProfile() async {
  if (_formKey.currentState!.validate()) {
    EasyLoading.show(status: 'Saving...');

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUser!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDocId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance.collection('users').doc(userDocId).update({
          'userName': _nameController.text, // Update username
          'profileImage': _profileImageUrl, // Update profile image URL from Firebase
        });

        EasyLoading.dismiss();
        Get.snackbar(
          "Profile Updated",
          "Your profile has been successfully updated",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        print('No user found for saving');
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        "Failed to update profile: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_profileImageUrl!),
                )
              else
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person),
                ),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.edit),
                label: const Text("Change Profile Picture"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: currentUser!.email,
                decoration: const InputDecoration(labelText: "Email"),
                readOnly: true, // Email can't be changed
              ),
              
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
