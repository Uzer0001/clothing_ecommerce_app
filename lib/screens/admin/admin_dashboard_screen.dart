import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product.dart';
import '../../widget/app_drawer.dart';
import '../../widget/category_cart.dart';
import '../../widget/product_cart.dart';


class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle sign out
              // You should call your AuthService sign out method here
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Product').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return const Center(child: Text('No products found.'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final product = Product.fromDocument(doc);
                    return ProductCard(product: product);
                  }).toList(),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('categories').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return const Center(child: Text('No categories found.'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final category = doc.data() as Map<String, dynamic>;
                    return CategoryCard(
                      title: category['name'],
                      onTap: () {
                        // Handle category tap
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
