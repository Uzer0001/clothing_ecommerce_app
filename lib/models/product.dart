import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double quntity;
  final double price;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.quntity,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id,
      title: data['title'],
      quntity:data['quntity']?.toDouble(),
      description: data['description'],
      price: data['price'].toDouble(),
      imageUrl: data['imageUrl'],
      category: data['category'],
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) 
 {
    return Product(
      id: json['id'],
      title: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(), 
      quntity:json['quntity'].toDouble(),
      description: json['description'],
      category:json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'imageUrl': imageUrl,
      'price': price,
      'quntity':quntity,
      'description': description,
      'category':category,
    };
  }
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      quntity: data['quntity'],
      price: data['price'],
      imageUrl: data['imageUrl'],
      category:data['category'],
    );
  }
}
