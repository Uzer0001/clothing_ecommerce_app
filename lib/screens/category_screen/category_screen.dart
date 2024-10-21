import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../category_product_list/category_product_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
   List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Future<void> _fetchCategories() async {
  //   try {
  //     // Fetch categories from Firestore
  //     CollectionReference categoryRef =
  //         FirebaseFirestore.instance.collection('categories');
  //     QuerySnapshot categorySnapshot = await categoryRef.get();
  //     List<Category> loadedCategories = categorySnapshot.docs.map((doc) {
  //       return Category.fromFirestore(doc);
  //     }).toList();

  //     setState(() {
  //       categories = loadedCategories;
  //     });
  //   } catch (error) {
  //     print("Error fetching categories: $error");
  //   }
  // }

  Future<void> _fetchCategories() async {
    try {
      // Fetch categories from Firestore
      CollectionReference categoryRef =
          FirebaseFirestore.instance.collection('categories');
      QuerySnapshot categorySnapshot = await categoryRef.get();
      List<Category> loadedCategories = categorySnapshot.docs.map((doc) {
        return Category.fromFirestore(doc);
      }).toList();

      setState(() {
        categories = loadedCategories;
      });
    } catch (error) {
      print("Error fetching categories: $error");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Categories'),
      ),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                Category category = categories[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: category.imageUrl != null
                        ? NetworkImage(category.imageUrl!)
                        : null,
                    child: category.imageUrl == null
                        ? const Icon(Icons.category)
                        : null,
                  ),
                  title: Text(category.name),
                  onTap: () {
                   Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => CategoryProductListScreen(
                                    categoryName: category.name,
                                  ),
                                ),
                              );
                  },
                );
              },
            ),
    );
  }
}