import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../widget/product_c.dart';
import '../product_detail_screen/product_detail_screen.dart';

class AllProductScreen extends StatelessWidget {
  final List<Product> products;
  const AllProductScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        itemBuilder: (ctx, i) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  productId: products[i].id,
                ),
              ),
            );
          },
          child: ProductC(
            title: products[i].title,
            price: products[i].price,
            imageUrl: products[i].imageUrl,
          ),
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4.4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
