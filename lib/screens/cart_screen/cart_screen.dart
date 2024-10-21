import 'package:clothing_app/controller/cart_price_controller.dart';
import 'package:clothing_app/models/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import '../checkout_screen/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController=Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Cart "),
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
            return const Center(
              child:  SizedBox(
                child: Text("No product has found",style: TextStyle(fontWeight: FontWeight.bold,),),
              ),
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
                            SizedBox(
                              width: Get.width / 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (cartModel.productQuntity > 1) {
                                  FirebaseFirestore.instance
                                      .collection('Cart')
                                      .doc(user!.uid)
                                      .collection('cartOrders')
                                      .doc(cartModel.productid)
                                      .update(
                                    {
                                      'productQuntity':
                                          cartModel.productQuntity - 1,
                                      'productTotalPrice': (cartModel.price *
                                          (cartModel.productQuntity - 1))
                                    },
                                  );
                                }
                              },
                              child: const CircleAvatar(
                                radius: 15.0,
                                backgroundColor: Colors.blueGrey,
                                child: Text("-"),
                              ),
                            ),
                            SizedBox(
                              width: Get.width / 10,
                            ),
                            SizedBox(
                              child: Text(
                                cartModel.productQuntity.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: Get.width / 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (cartModel.productQuntity > 0) {
                                  FirebaseFirestore.instance
                                      .collection('Cart')
                                      .doc(user!.uid)
                                      .collection('cartOrders')
                                      .doc(cartModel.productid)
                                      .update(
                                    {
                                      'productQuntity':
                                          cartModel.productQuntity + 1,
                                      'productTotalPrice': (cartModel.price *
                                          (cartModel.productQuntity + 1))
                                    },
                                  );
                                }
                              },
                              child: const CircleAvatar(
                                radius: 15.0,
                                backgroundColor: Colors.blueGrey,
                                child: Text("+"),
                              ),
                            ),
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
        margin: const EdgeInsets.only(bottom: 5.0, left: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
             Obx(() => Text(
              "Rs.${productPriceController.totalPrice.value.toString()}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),),
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
                        Get.to(()=>const CheckoutScreen());
                      },
                      child: const Text(
                        "Chekout",
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
}
