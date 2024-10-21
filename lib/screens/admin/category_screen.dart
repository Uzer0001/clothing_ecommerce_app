import 'package:clothing_app/models/category.dart';
import 'package:clothing_app/screens/admin/edit_category/edit_category.dart';
import 'package:clothing_app/widget/category_cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  Future<void> navigateToProductDetails(
      BuildContext context, String documentId) async {
    // Handle potential deletion in ProductDetailsScreen (explained there)
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditCategoryScreen(categoryId: documentId),
      ),
    );
  }

  void _deleteCategorie(String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('categorie delete sucsessfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('error deleteing categorie'),
          backgroundColor: Colors.red,
        ),
      );
      print(error);
    }
  }

   void _showDeleteConfirmationDialog(String categoryId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("Do you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              _deleteCategorie(categoryId);
              Navigator.of(ctx).pop(); // Close the dialog after deletion
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Category"),),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('categories').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return const Center(child: Text('No category found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot doc = snapshot.data!.docs[index];
                    final category = Category.fromDocument(doc);

                    return GestureDetector(
                      onLongPress: () => _showDeleteConfirmationDialog(
                          doc.id), // Trigger deletion dialog on long press
                      onTap: () => navigateToProductDetails(
                          context, doc.id), // Navigate to details on tap
                      child: CategoryCard(category: category),
                    );
                  },
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed("/addCategory");
              },
              child: const Text(
                "Add Category",
                style: TextStyle(fontSize: 22.0, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
