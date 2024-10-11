import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProductListScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  const CategoryProductListScreen({super.key, required this.categoryId, required this.categoryName});

  Future<List<Map<String, dynamic>>> fetchCategoryProducts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Product')
          .where('category', isEqualTo: categoryName) 
          .get();

      // Convert Firestore documents into a list of products
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (error) {
      throw Exception('Error fetching category products: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Products'),
      ),
      body: FutureBuilder(
        future: fetchCategoryProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found in this category.'));
          } else {
            List<Map<String, dynamic>> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, index) {
                var product = products[index];
                return ListTile(
                  leading: Image.network(product['imageUrl']),
                  title: Text(product['title']),
                  subtitle: Text('\$${product['price']}'),
                  onTap: () {
                    // Navigate to product detail screen if needed
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}