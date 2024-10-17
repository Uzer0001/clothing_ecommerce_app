import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/product.dart';

class AddToCart extends StatefulWidget {
  final String productId;
  const AddToCart({
    super.key,
    required this.productId,
  });

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  int curruntIndex = 1;
  User? user = FirebaseAuth.instance.currentUser;

  Future<Product?> fetchProductDetails(String productId) async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('Product')
          .doc(productId)
          .get();

      if (productSnapshot.exists) {
        // Return a Product object
        return Product.fromDocument(productSnapshot);
      } else {
        print("Product not found");
        return null;
      }
    } catch (e) {
      print("Error fetching product details: $e");
      return null;
    }
  }

  Future<String?> fetchCategoryIdByName(String categoryName) async {
    try {
      // Query Firestore to get the category with the matching name
      QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('name', isEqualTo: categoryName)
          .limit(1)
          .get();

      if (categorySnapshot.docs.isNotEmpty) {
        // Return the document ID (categoryId) of the first matching document
        return categorySnapshot.docs.first.id;
      } else {
        print("Category not found");
        return null;
      }
    } catch (e) {
      print("Error fetching category ID: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Container(
        height: 85,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.white),
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await checkProductExistence(uId: user!.uid);
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(50)),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: const Text(
                  "Add To Cart",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> checkProductExistence(
      {required String uId, int quantityIncrement = 1}) async {
    Product? product = await fetchProductDetails(widget.productId);
    String? categoryId = await fetchCategoryIdByName(product!.category);
    final DocumentReference doc = FirebaseFirestore.instance
        .collection('Cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productId);
    DocumentSnapshot snapshot = await doc.get();

    if (snapshot.exists) {
      int curruntQuantity = snapshot['productQuntity'];
      int updatedQuantity = curruntQuantity + quantityIncrement;
      double totalPrice = product.price * updatedQuantity;
      await doc.update({
        'productQuntity': updatedQuantity,
        'productTotalPrice': totalPrice,
      });
      print("product allready exist");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Allready exist in cart,incresing quntity'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      await FirebaseFirestore.instance.collection('Cart').doc(uId).set(
        {
          'uId': uId,
          'createdAt': DateTime.now(),
        },
      );
      Cart cartModel = Cart(
        productid: widget.productId,
        categoryId: categoryId.toString(),
        productName: product.title,
        price: product.price,
        quntity: product.quntity,
        productImageUrl: product.imageUrl,
        productDescription: product.description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuntity: 1,
        productTotalPrice: product.price,
      );
      await doc.set(cartModel.toMap());
      print("add to cart succesfully");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add to cart product successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
