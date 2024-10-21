import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/orders.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Orders"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Get all users from the 'orders' collection
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching orders"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No orders found"),
            );
          }

          // List to hold all orders from all users
          List<Orders> allOrders = [];

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final userDoc = snapshot.data!.docs[index];

              // Access the 'confirmOrders' sub-collection for each user
              return StreamBuilder<QuerySnapshot>(
                stream: userDoc.reference.collection('confirmOrders').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> ordersSnapshot) {
                  if (ordersSnapshot.hasError) {
                    return const Center(
                      child: Text("Error fetching user's orders"),
                    );
                  }

                  if (ordersSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (ordersSnapshot.data!.docs.isEmpty) {
                    return const ListTile(
                      title: Text("No orders for this user"),
                    );
                  }

                  // Fetching all orders from this user's confirmOrders
                  for (var orderDoc in ordersSnapshot.data!.docs) {
                    Orders orderModel = Orders(
                      productid: orderDoc['productid'],
                      categoryId: orderDoc['categoryId'],
                      productName: orderDoc['productName'],
                      categoryName: orderDoc['categoryName'],
                      price: orderDoc['price'],
                      productImage: orderDoc['productImage'],
                      productDescription: orderDoc['productDescription'],
                      createdAt: orderDoc['createdAt'],
                      updatedAt: orderDoc['updatedAt'],
                      productQuntity: orderDoc['productQuntity'],
                      productTotalPrice: orderDoc['productTotalPrice'],
                      customerId: orderDoc['customerId'],
                      status: orderDoc['status'],
                      customerName: orderDoc['customerName'],
                      customerPhone: orderDoc['customerPhone'],
                      customerAddress: orderDoc['customerAddress'],
                      customerDeviceToken: orderDoc['customerDeviceToken'],
                    );

                    allOrders.add(orderModel);
                  }

                  return ExpansionTile(
                    title: Text(userDoc.id), // Display the user ID or username
                    children: allOrders.map((order) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          backgroundImage: NetworkImage(order.productImage),
                        ),
                        title: Text(order.productName),
                        subtitle: Text('Total Price: \$${order.productTotalPrice}'),
                      );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
