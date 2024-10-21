import 'dart:io'; // Import for File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../models/category.dart';

class EditCategoryScreen extends StatefulWidget {
  final String categoryId;

  const EditCategoryScreen({super.key, required this.categoryId});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();
  String? _categoryImageUrl; // Store the uploaded image URL
  File? _selectedImage; // Variable to hold the selected image
  final ImagePicker _imagePicker = ImagePicker();
  late Category _category;

  @override
  void initState() {
    super.initState();
    // Fetch the category details when the screen initializes
    _fetchCategoryDetails();
  }

  Future<void> _fetchCategoryDetails() async {
    final categoryDoc = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .get();

    if (categoryDoc.exists) {
      _category = Category.fromFirestore(categoryDoc);
      _categoryNameController.text = _category.name;
      _categoryImageUrl = _category.imageUrl; // Keep the existing image URL
      setState(() {}); // Update the UI
    } else {
      Get.snackbar('Error', 'Category not found',
          snackPosition: SnackPosition.BOTTOM);
      Navigator.pop(context);
    }
  }

  Future<void> _updateCategory() async {
    EasyLoading.show(status: "Please Wait");
    if (_formKey.currentState!.validate()) {

      String imageUrl = _categoryImageUrl ?? ''; // Use the existing URL or an empty string

      // If a new image is selected, upload it to Firebase Storage
      if (_selectedImage != null) {
        imageUrl = await _uploadImage(); // Upload image and get the URL
      }

      // Update the category in Firestore
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .update({
        'name': _categoryNameController.text,
        'imageUrl': imageUrl,
      });
      EasyLoading.dismiss();
      Get.snackbar('Success', 'Category updated successfully',
          snackPosition: SnackPosition.BOTTOM);
      Navigator.pop(context);
    }
  }

  Future<String> _uploadImage() async {
    if (_selectedImage != null) {
      // Define the storage reference
      Reference storageRef = FirebaseStorage.instance.ref().child('category_images/${_selectedImage!.path.split('/').last}');
      
      // Upload the image
      await storageRef.putFile(_selectedImage!);
      
      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl; // Return the download URL
    }
    return ''; // Return an empty string if no image is picked
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _categoryNameController,
                decoration: const InputDecoration(
                  labelText: "Category Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Display the selected image or prompt to select a new one
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : _categoryImageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                _categoryImageUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(child: Text("Select Image")),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateCategory,
                child: const Text("Update Category"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
}
