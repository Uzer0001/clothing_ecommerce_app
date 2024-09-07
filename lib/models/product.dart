import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      price: data['price'].toDouble(),
      imageUrl: data['imageUrl'],
    );
  }

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['imageUrl'],
    );
  }
}
