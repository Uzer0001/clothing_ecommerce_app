import 'package:clothing_app/models/product.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier{
  final List<Product> _cart=[];
  List<Product> get cart =>_cart;
  void toggleFavorite(Product product){
    
  }
}