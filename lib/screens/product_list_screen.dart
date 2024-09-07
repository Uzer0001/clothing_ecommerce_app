import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});
  static const routeName = '/product-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: FutureBuilder(
        future: Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred!'));
          } else {
            return Consumer<ProductProvider>(
              builder: (ctx, productsProvider, child) {
                return ListView.builder(
                  itemCount: productsProvider.products.length,
                  itemBuilder: (ctx, index) {
                    final product = productsProvider.products[index];
                    return ListTile(
                      leading: Image.network(product.imageUrl, fit: BoxFit.cover, width: 50, height: 50),
                      title: Text(product.title),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      onTap: () {
                        // Handle product tap (e.g., navigate to detail screen)
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}