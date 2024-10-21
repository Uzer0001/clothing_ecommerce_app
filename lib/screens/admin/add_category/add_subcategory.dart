// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddSubcategory extends StatefulWidget {
  final String categoryId;

  const AddSubcategory({required this.categoryId, super.key});

  @override
  _AddSubcategoryState createState() => _AddSubcategoryState();
}

class _AddSubcategoryState extends State<AddSubcategory> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  String? _subcategoryImageLink;
  TextEditingController nameController = TextEditingController();

  Future<void> getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  Future<void> _submitSubcategory() async {
    if (_formKey.currentState!.validate() && selectedImage != null) {
      try {
        // Upload image to Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('subcategories/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = ref.putFile(selectedImage!);
        final snapshot = await uploadTask.whenComplete(() => null);
        _subcategoryImageLink = await snapshot.ref.getDownloadURL();

        // Create subcategory document in Firestore
        final subcategoryData = {
          'name': nameController.text,
          'imageUrl': _subcategoryImageLink,
        };
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(widget.categoryId)
            .collection('subcategories') // Add to subcategories collection
            .add(subcategoryData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subcategory added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Return to the previous screen
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error adding subcategory'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Subcategory")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: getImage,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: selectedImage == null
                      ? const Center(child: Icon(Icons.camera_alt_outlined))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Subcategory Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subcategory name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitSubcategory,
                child: const Text("Add Subcategory"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
