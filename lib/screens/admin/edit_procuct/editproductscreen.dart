import 'dart:io'; // Import for File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;

  const EditProductScreen({super.key, required this.productId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  String? _productImageUrl; // Store the uploaded image URL
  File? _selectedImage; // Variable to hold the selected image
  final ImagePicker _imagePicker = ImagePicker();
  late Product _product; // Assuming you have a Product model

  @override
  void initState() {
    super.initState();
    // Fetch the product details when the screen initializes
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    final productDoc = await FirebaseFirestore.instance
        .collection('Product')
        .doc(widget.productId)
        .get();

    if (productDoc.exists) {
      _product = Product.fromFirestore(productDoc);
      _titleController.text = _product.title;
      _descriptionController.text = _product.description;
      _quantityController.text = _product.quntity.toString();
      _priceController.text = _product.price.toString();
      _categoryController.text = _product.category;
      _productImageUrl = _product.imageUrl; // Keep the existing image URL
      setState(() {}); // Update the UI
    } else {
      Get.snackbar('Error', 'Product not found',
          snackPosition: SnackPosition.BOTTOM);
      Navigator.pop(context);
    }
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      String imageUrl = _productImageUrl ?? ''; // Use the existing URL or an empty string

      // If a new image is selected, upload it to Firebase Storage
      if (_selectedImage != null) {
        imageUrl = await _uploadImage(); // Upload image and get the URL
      }

      // Update the product in Firestore
      await FirebaseFirestore.instance
          .collection('Product')
          .doc(widget.productId)
          .update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'quntity': double.parse(_quantityController.text),
        'price': double.parse(_priceController.text),
        'imageUrl': imageUrl,
        'category': _categoryController.text,
      });

      // Show a success message and go back to the previous screen
      Get.snackbar('Success', 'Product updated successfully',
          snackPosition: SnackPosition.BOTTOM);
      Navigator.pop(context);
    }
  }

  Future<String> _uploadImage() async {
    if (_selectedImage != null) {
      // Define the storage reference
      Reference storageRef = FirebaseStorage.instance.ref().child('product_images/${_selectedImage!.path.split('/').last}');
      
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
        title: const Text("Edit Product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Product Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Product Description",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: "Product Quantity",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: "Product Price",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: "Product Category",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product category';
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
                        : _productImageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _productImageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(child: Text("Select Image")),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _updateProduct,
                  child: const Text("Update Product"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Update the image with the selected file
      });
    }
  }
}
