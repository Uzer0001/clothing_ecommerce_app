import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(product.imageUrl, fit: BoxFit.cover, width: 100, height: 100),
        title: Text(product.title),
        subtitle: Text('\$${product.price.toString()}')
      ),
    );
  }
}
