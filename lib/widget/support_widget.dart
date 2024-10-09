import 'package:flutter/material.dart';

class AppWidget{
  static TextStyle boldTextfieldStyle(){
    return const TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
    );
  }
  static TextStyle lightTextFieldStyle(){
    return const TextStyle(
      color: Colors.black54,
      fontSize: 20.0,
      fontWeight:FontWeight.w500,
    );
  }
  static TextStyle semiBoldTextfieldsize(){
    return const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold);
  }
}