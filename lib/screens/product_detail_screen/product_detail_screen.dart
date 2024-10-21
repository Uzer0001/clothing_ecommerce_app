import 'package:clothing_app/widget/add_to_cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  Future<Map<String, dynamic>?> fetchProductDetails(String productId) async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('Product')
          .doc(productId)
          .get();

      return productSnapshot.data() as Map<String, dynamic>?;
    } catch (error) {
      print("Error fetching product details: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color(0xFFfef5f1),
      floatingActionButton: AddToCart(productId: productId),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchProductDetails(productId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error fetching product details"));
          }

          final productData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    productData['imageUrl'],
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  productData['title'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Price: Rs.${productData['price']}",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  productData['description'],
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 100.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
 
}
