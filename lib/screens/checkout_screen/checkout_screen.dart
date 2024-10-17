import 'package:clothing_app/controller/cart_price_controller.dart';
import 'package:clothing_app/models/cart.dart';
import 'package:clothing_app/services/place_order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import '../../controller/get_customer_device_token_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout "),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const SizedBox(
              child: Text("error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 5,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const SizedBox(
              child: Text("No product has found"),
            );
          }
          if (snapshot.data != null) {
            return SizedBox(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  Cart cartModel = Cart(
                    productid: productData['productid'],
                    categoryId: productData['categoryId'],
                    productName: productData['productName'],
                    price: productData['price'],
                    quntity: productData['quntity'],
                    productImageUrl: productData['productImageUrl'],
                    productDescription: productData['productDescription'],
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt'],
                    productQuntity: productData['productQuntity'],
                    productTotalPrice: productData['productTotalPrice'],
                  );

                  productPriceController.fetchProductPrice();
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productid),
                    trailingActions: [
                      SwipeAction(
                        title: "Delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          print("Deleted");

                          await FirebaseFirestore.instance
                              .collection('Cart')
                              .doc(user!.uid)
                              .collection('cartOrders')
                              .doc(cartModel.productid)
                              .delete();
                        },
                      ),
                    ],
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          backgroundImage:
                              NetworkImage(cartModel.productImageUrl),
                        ),
                        title: Text(cartModel.productName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(cartModel.productTotalPrice.toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20.0, left: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Text(
                "Rs.${productPriceController.totalPrice.value.toString()}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  child: TextButton(
                      onPressed: () {
                        showCustomBottonSheet();
                      },
                      child: const Text(
                        "Confirm Chekout",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showCustomBottonSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: SizedBox(
                  height: 55.0,
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null) {
                        return "please enter Name";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("Name"),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: SizedBox(
                  height: 55.0,
                  child: TextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value == null) {
                        return "please enter Phone number";
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      label: Text("Phone"),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: SizedBox(
                  height: 55.0,
                  child: TextFormField(
                    controller: addressController,
                    validator: (value) {
                      if (value == null) {
                        return "please enter Address";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("Address"),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10)),
                onPressed: () async{
                  if (nameController.text.isNotEmpty&&
                      phoneController.text.isNotEmpty &&
                      addressController.text.isNotEmpty) {
                    String name = nameController.text.trim();
                    String phone = phoneController.text.trim();
                    String address = addressController.text.trim();

                    String customerToken=await getCustomerDeviceToken();

                    placeOrder(
                      context:context,
                      customerName:name,
                      customerPhone:phone,
                      customerAddress:address,
                      customerDeviceToken:customerToken,
                    );
                  } else {
                    Get.snackbar("please Enter all details", "");
                  }
                },
                child: const Text(
                  "Place Order",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }
}
