import 'package:clothing_app/screens/product_detail_screen/product_detail_screen.dart';
import 'package:clothing_app/widget/product_c.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductGridView extends StatelessWidget {
  final String categoryName;
  const ProductGridView({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Product') // Collection in Firestore
          .where('category',
              isEqualTo: categoryName) // Filter products by category
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching products'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text('No products available in this category'));
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 /4.4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailScreen(productId: product.id)));
              },
              child: ProductC(
                title: product['title'],
                price: product['price'],
                imageUrl: product['imageUrl'],
              ),
            );
          },
        );
      },
    );
  }
}
