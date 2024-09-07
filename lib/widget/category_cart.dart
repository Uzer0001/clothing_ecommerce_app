import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
