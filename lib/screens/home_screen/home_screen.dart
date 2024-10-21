// import 'package:clothing_app/widget/app_drawer.dart';
import 'package:clothing_app/screens/all_product_screen/all_product_screen.dart';
import 'package:clothing_app/widget/app_drawer.dart';
import 'package:clothing_app/widget/support_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product.dart';
import '../category_product_list/category_product_list.dart';
import '../product_detail_screen/product_detail_screen.dart';
// import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String? displayName;

  List<Category> categories = [];
  List<Product> products = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchCategories();
  }

  Future<void> _fetchUserName() async {
    try {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the user data from Firestore using the UID
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Check if the document exists and set the display name
        if (userDoc.exists) {
          setState(() {
            displayName = userDoc['userName'] ?? 'User'; // default to 'User' if no displayName field
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
  Future<void> _fetchCategories() async {
    try {
      // Fetch categories
      CollectionReference categoryRef =
          FirebaseFirestore.instance.collection('categories');
      QuerySnapshot categorySnapshot = await categoryRef.get();
      List<Category> loadedCategories = categorySnapshot.docs.map((doc) {
        return Category.fromFirestore(doc);
      }).toList();

      // Fetch products (optional: within a separate function)
      CollectionReference productRef =
          FirebaseFirestore.instance.collection('Product');
      QuerySnapshot productSnapshot = await productRef.get();
      List<Product> loadedProducts = productSnapshot.docs.map((doc) {
        return Product.fromFirestore(doc);
      }).toList();

      // Update state with both categories and products
      setState(() {
        categories = loadedCategories;
        products = loadedProducts;
        filteredProducts = loadedProducts;
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = products;
      });
    } else {
      setState(() {
        filteredProducts = products.where((product) {
          final matches =
              product.title.toLowerCase().contains(query.toLowerCase());
          print(
              'Filtering: ${product.title}, Matches: $matches'); // Debugging line
          return matches;
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: const Color(0xfff2f2f2),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Hey ${displayName ?? 'User'}",
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
                  controller: _searchController,
                  onChanged: _filterProducts,
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
        
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => CategoryProductListScreen(
                                      categoryName: category.name,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: category.imageUrl != null
                                          ? NetworkImage(category.imageUrl!)
                                          : null, // Fallback icon
                                      radius:
                                          30.0, // Display an image if available
                                      child: category.imageUrl == null
                                          ? const Icon(Icons.category, size: 30)
                                          : null,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(category.name),
                                  ],
                                ),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllProductScreen(
                                    products: products,
                                  )));
                    },
                    child: const Text("See all",
                        style: TextStyle(
                            color: Color(0xfffd6f3e),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                  )
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
                  children: filteredProducts.isEmpty
                      ? [const Center(child: CircularProgressIndicator())]
                      : filteredProducts
                          .map(
                            (product) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      productId: product.id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 20.0),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                width: 200, 
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      product.imageUrl, // Use product's imageUrl
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.contain,
                                    ),
                                    Flexible(
                                      child: Text(
                                        product.title, // Use product's name
                                        style: AppWidget.semiBoldTextfieldsize(),
                                        maxLines:2,// Allow the text to take up to 2 lines
                                        overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Rs.${product.price}", // Use product's price
                                          style: const TextStyle(
                                              color: Color(0xfffd6f3e),
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xfffd6f3e),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
