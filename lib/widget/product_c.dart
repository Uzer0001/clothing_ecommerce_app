import 'package:flutter/material.dart';

class ProductC extends StatelessWidget {
   final String title;
  final double price;
  final String imageUrl;
  const ProductC({super.key, required this.title, required this.price, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
   return Card(
      elevation: 5,
      child: Column(
        children: [
          Expanded(
            child: Image.network(imageUrl, fit: BoxFit.cover), // Product image
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text('Rs.${price.toString()}', style: const TextStyle(color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}