import 'package:clothing_app/models/category.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
final Category category;

  const CategoryCard({super.key, required this.category,});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: category.imageUrl != null && category.imageUrl!.isNotEmpty
            ? Image.network(
                category.imageUrl!,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              )
            : const Icon(
                Icons.image,
                size: 50, // Provide a fallback icon when there's no image
              ),
        title: Text(category.name),
      ),
    );
  }
}
