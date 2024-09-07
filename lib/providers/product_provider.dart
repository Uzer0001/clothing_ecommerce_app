import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  ProductProvider(String? token);

  List<Product> get products {
    return [..._products];
  }

  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Product').get();
      _products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
