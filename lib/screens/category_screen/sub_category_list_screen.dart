import 'package:flutter/material.dart';
import '../../models/subCategory.dart';

class SubcategoryListScreen extends StatelessWidget {
  final List<SubCategory> subCategories;

  const SubcategoryListScreen({super.key, required this.subCategories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subcategories'),
      ),
      body: ListView.builder(
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          SubCategory subCategory = subCategories[index];
          return ListTile(
            title: Text(subCategory.name),
            onTap: () {
              // Handle navigation to subcategory products or details
              // Example: Navigator.of(context).push(...);
            },
          );
        },
      ),
    );
  }
}
