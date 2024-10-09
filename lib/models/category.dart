import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name;
  final String? imageUrl;

  Category({
    required this.name,
    required this.imageUrl
  });

  factory Category.fromDocument(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return Category(name: data['name'], imageUrl: data['imageUrl']);
  }

  factory Category.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return Category(name: data['name'], imageUrl: data['imageUrl']);
  }
}