import 'package:clothing_app/models/orders.dart';
import 'package:clothing_app/services/genrate_order_id_service.dart';
import 'package:clothing_app/widget/navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void placeOrder(
    {required BuildContext context,
    required String customerAddress,
    required String customerPhone,
    required String customerName,
    required String customerDeviceToken}) async {
  final user = FirebaseAuth.instance.currentUser;
  EasyLoading.show(status: "Please Wait..");
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
        String orderId = generateOrderId();

        Orders ordersModel = Orders(
          productid: data['productid'] ?? '',
          categoryId: data['categoryId'] ?? '',
          productName: data['productName'] ?? 'Unknown Product',
          categoryName: data['categoryName'] ?? 'Unknown Category',
          price: data['price'] ?? 0.0,
          productImage: data['productImageUrl'] ?? '',
          productDescription: data['productDescription'] ?? 'No Description',
          createdAt: DateTime.now(),
          updatedAt:
              (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          productQuntity: data['productQuntity'] ?? 1,
          productTotalPrice: data['productTotalPrice'] ?? 0.0,
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken,
        );
        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set(
            {
              'uId': user.uid,
              'customerName': customerName,
              'customerPhone': customerPhone,
              'customerAddress': customerAddress,
              'customerDeviceToken': customerDeviceToken,
              'orderStatus': false,
              'createdAt': DateTime.now(),
            },
          );

          await FirebaseFirestore.instance
              .collection("orders")
              .doc(user.uid)
              .collection("confirmOrders")
              .doc(orderId)
              .set(ordersModel.toMap());

          await FirebaseFirestore.instance
              .collection("Cart")
              .doc(user.uid)
              .collection('cartOrders')
              .doc(ordersModel.productid.toString())
              .delete()
              .then((value) {
            print("Delete cart products $ordersModel.productid.toString()");
          });
        }
      }
      print('Order Confirm');
      Get.snackbar(
        "Order Confirmed",
        "Thank you for your order",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      EasyLoading.dismiss();
      Get.offAll(() => const NavigationMenu());
    } catch (e) {
      print("Error $e");
    }
  }
}
