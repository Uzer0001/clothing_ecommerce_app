import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:random_string/random_string.dart';
import '../../../widget/support_widget.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  String? _productImageLink;
  String? selectedCategory;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController quntitycontroller = TextEditingController();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  Future<List<String>> fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: "Please wait");
      try {
        // Upload image to Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('products/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = ref.putFile(File(selectedImage!.path));
        final snapshot = await uploadTask.whenComplete(() => null);
        _productImageLink = await snapshot.ref.getDownloadURL();

        // Create product document in Firestore
        final productData = {
          'title': namecontroller.text,
          'description': descriptioncontroller.text,
          'price': double.parse(pricecontroller.text),
          'quntity': double.parse(quntitycontroller.text),
          'imageUrl': _productImageLink,
          'category': selectedCategory,
        };
        await FirebaseFirestore.instance.collection('Product').add(productData);
        EasyLoading.dismiss();
        // Show success message or navigate to product list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        
      } catch (e) {
        // Handle error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Error adding product'),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
  }
  // uplodedImage() async {
  //   if (selectedImage != null &&
  //       namecontroller.text != "" &&
  //       descriptioncontroller.text != "" &&
  //       pricecontroller.text != "" &&
  //       quntitycontroller.text != "") {
  //     String addId = randomAlphaNumeric(10);
  //     Reference firebaseStorageRef =
  //         FirebaseStorage.instance.ref().child("ProductImage").child(addId);

  //     final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
  //     var downlodUrl = await (await task).ref.getDownloadURL();

  //     Map<String, dynamic> addProduct = {
  //       'name': namecontroller.text,
  //       'imageUrl': downlodUrl,
  //       'description': descriptioncontroller.text,
  //       'price': pricecontroller.text,
  //       'quntity': quntitycontroller.text
  //     };
  //   }
  // }

  String? value;
  // final List<String> categoryitem = ['male', 'female'];

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
          "Add Product",
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
                  "Upload Product Image",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                selectedImage == null
                    ? GestureDetector(
                        onTap: () => getImage(),
                        child: Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1.5),
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
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
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
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Product Name",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    controller: namecontroller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Product Category",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //       color: const Color(0xFFececf8),
                //       borderRadius: BorderRadius.circular(20)),
                //   child: DropdownButtonHideUnderline(
                //     child: DropdownButton<String>(
                //       items: categoryitem
                //           .map((item) => DropdownMenuItem(
                //               value: item,
                //               child: Text(item,
                //                   style: AppWidget.semiBoldTextfieldsize())))
                //           .toList(),
                //       onChanged: ((value) => setState(() {
                //             this.value = value;
                //           })),
                //       dropdownColor: Colors.white,
                //       hint: const Text("Select Category"),
                //       iconSize: 36,
                //       icon: const Icon(
                //         Icons.arrow_drop_down,
                //         color: Colors.black,
                //       ),
                //       value: value,
                //     ),
                //   ),
                // ),
                FutureBuilder<List<String>>(
                  future: fetchCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final categories = snapshot.data!;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value!;
                              });
                            },
                            items: categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category,
                                    style: AppWidget.semiBoldTextfieldsize()),
                              );
                            }).toList(),
                            dropdownColor: Colors.white,
                            hint: const Text("Select Category"),
                            iconSize: 36,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Description",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    maxLines: 6,
                    controller: descriptioncontroller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Price",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  keyboardType: TextInputType.number,
                    controller: pricecontroller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Quntity",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  keyboardType: TextInputType.number,
                    controller: quntitycontroller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () {
                      _submitProduct();
                    },
                    child: const Text(
                      "Add Product",
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
