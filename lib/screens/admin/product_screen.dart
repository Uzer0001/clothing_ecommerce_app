import 'package:clothing_app/screens/admin/edit_procuct/editproductscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../widget/product_cart.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<void> navigateToProductDetails(
      BuildContext context, String documentId) async {
    // Handle potential deletion in ProductDetailsScreen (explained there)
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProductScreen(productId: documentId),
      ),
    );
  }

  void _deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Product')
          .doc(productId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product delete sucsessfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('error deleteing product'),
          backgroundColor: Colors.red,
        ),
      );
      print(error);
    }
  }

  void _showDeleteConfirmationDialog(String productId) {
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
              _deleteProduct(productId);
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
      appBar: AppBar(title: const Text("products"),),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Product').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return const Center(child: Text('No products found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot doc = snapshot.data!.docs[index];
                    final product = Product.fromDocument(doc);

                    return GestureDetector(
                      onLongPress: () => _showDeleteConfirmationDialog(
                          doc.id), // Trigger deletion dialog on long press
                      onTap: () => navigateToProductDetails(
                          context, doc.id), // Navigate to details on tap
                      child: ProductCard(product: product),
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
                Navigator.of(context).pushNamed("/addProduct");
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
    );
  }
}
