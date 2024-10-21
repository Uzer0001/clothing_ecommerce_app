import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widget/support_widget.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  String? _categoriesImageLink;
  TextEditingController nameController = TextEditingController();
  List<TextEditingController> subcategoryControllers = [];

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  Future<void> _submitCategory() async {
    if (_formKey.currentState!.validate() && selectedImage != null) {
      try {
        // Upload image to Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('categories/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = ref.putFile(selectedImage!);
        final snapshot = await uploadTask;
        _categoriesImageLink = await snapshot.ref.getDownloadURL();

        // Prepare subcategories
        List<String> subcategories = [];
        for (var controller in subcategoryControllers) {
          subcategories.add(controller.text);
        }

        // Create category document in Firestore
        final categoryData = {
          'name': nameController.text,
          'imageUrl': _categoriesImageLink,
          'subCategories': subcategories,
        };
        await FirebaseFirestore.instance
            .collection('categories')
            .add(categoryData);

        // Show success message or navigate to product list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        // Reset form after submission
        _resetForm();
      } catch (e) {
        // Handle error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Error adding category'),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
  }

  void _resetForm() {
    selectedImage = null;
    nameController.clear();
    for (var controller in subcategoryControllers) {
      controller.clear();
    }
    subcategoryControllers.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text(
          "Add Category",
          style: AppWidget.semiBoldTextfieldsize(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload Category Image",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(height: 20.0),
                selectedImage == null
                    ? GestureDetector(
                        onTap: () => getImage(),
                        child: Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.5),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Icon(Icons.camera_alt_outlined),
                          ),
                        ),
                      )
                    : Center(
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20.0),
                Text(
                  "Category Name",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30.0),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: _submitCategory,
                    child: const Text(
                      "Add Category",
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
