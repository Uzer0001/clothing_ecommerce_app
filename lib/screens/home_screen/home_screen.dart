// import 'package:clothing_app/widget/app_drawer.dart';
import 'package:clothing_app/widget/app_drawer.dart';
import 'package:clothing_app/widget/support_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();

    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      // Fetch the collection 'categories' from Firestore
      CollectionReference categoryRef =
          FirebaseFirestore.instance.collection('categories');

      // Retrieve the documents in the collection
      QuerySnapshot snapshot = await categoryRef.get();

      // Convert each document into a Category object
      List<Category> loadedCategories = snapshot.docs.map((doc) {
        return Category.fromFirestore(
            doc); // Pass the DocumentSnapshot to the factory
      }).toList();

      // Update the state with the loaded categories
      setState(() {
        categories = loadedCategories;
      });
    } catch (error) {
      print("Error fetching categories: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: const Color(0xfff2f2f2),
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Hey ${user?.displayName ?? 'User'}",
                  style: AppWidget.boldTextfieldStyle(),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: AppWidget.lightTextFieldStyle(),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    )),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Categories", style: AppWidget.semiBoldTextfieldsize()),
                const Text("See all",
                    style: TextStyle(
                        color: Color(0xfffd6f3e),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(
              height: 100.0,
              child: categories.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      // color: Colors.black,
                      margin: const EdgeInsets.only(left: 20.0),

                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          // Extract the category data
                          Category category = categories[index];

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: category.imageUrl != null
                                      ? NetworkImage(category.imageUrl!)
                                      : null, // Fallback icon
                                  radius: 30.0, // Display an image if available
                                  child: category.imageUrl == null
                                      ? const Icon(Icons.category, size: 30)
                                      : null,
                                ),
                                const SizedBox(height: 5.0),
                                Text(category.name),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("All Product", style: AppWidget.semiBoldTextfieldsize()),
                const Text("See all",
                    style: TextStyle(
                        color: Color(0xfffd6f3e),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              height: 240,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/logo/logo.jpg",
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "Tshirt",
                          style: AppWidget.semiBoldTextfieldsize(),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Rs.500",
                              style: TextStyle(
                                  color: Color(0xfffd6f3e),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 50.0,
                            ),
                            Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: const Color(0xfffd6f3e),
                                    borderRadius: BorderRadius.circular(7)),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/logo/logo.jpg",
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "Tshirt",
                          style: AppWidget.semiBoldTextfieldsize(),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Rs.500",
                              style: TextStyle(
                                  color: Color(0xfffd6f3e),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 50.0,
                            ),
                            Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: const Color(0xfffd6f3e),
                                    borderRadius: BorderRadius.circular(7)),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/logo/logo.jpg",
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "Tshirt",
                          style: AppWidget.semiBoldTextfieldsize(),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Rs.500",
                              style: TextStyle(
                                  color: Color(0xfffd6f3e),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 50.0,
                            ),
                            Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: const Color(0xfffd6f3e),
                                    borderRadius: BorderRadius.circular(7)),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // appBar: AppBar(
      //   title: const Text('Clothing Store'),
      // ),
      // drawer: AppDrawer(),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance.collection('Product').snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     }
      //     final products = snapshot.data!.docs;
      //     return GridView.builder(
      //       padding: const EdgeInsets.all(10.0),
      //       itemCount: products.length,
      //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //         crossAxisCount: 2,
      //         childAspectRatio: 3 / 2,
      //         crossAxisSpacing: 10,
      //         mainAxisSpacing: 10,
      //       ),
      //       itemBuilder: (context, index) {
      //         final product = products[index];
      //         return GestureDetector(
      //           onTap: () {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (context) => ProductDetailScreen(
      //                   productId: product.id,
      //                 ),
      //               ),
      //             );
      //           },
      //           child: GridTile(
      //             footer: GridTileBar(
      //               backgroundColor: Colors.black87,
      //               title: Text(
      //                 product['title'],
      //                 textAlign: TextAlign.center,
      //               ),
      //               subtitle: Text(
      //                 '\$${product['price'].toString()}',
      //                 textAlign: TextAlign.center,
      //               ),
      //             ),
      //             child: Image.network(
      //               product['imageUrl'],
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
