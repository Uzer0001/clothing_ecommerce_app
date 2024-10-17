import 'package:clothing_app/widget/product_grid_view.dart';
import 'package:flutter/material.dart';

class CategoryProductListScreen extends StatelessWidget {
  final String categoryName;
  const CategoryProductListScreen({super.key, required this.categoryName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Products'),
      ),
      body: ProductGridView(categoryName: categoryName),
    );
  }
}