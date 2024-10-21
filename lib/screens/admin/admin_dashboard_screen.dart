import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widget/support_widget.dart';
import '../auth/login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  AdminDashboardScreen({super.key});

  final List<Map<String, dynamic>> _dashboardItems = [
    {
      'title': 'Product',
      'image': 'assets/logo/cover_logo.png',
      'route': '/productScreen',
    },
    {
      'title': 'Category',
      'image': 'assets/logo/category_logo.jpeg',
      'route': '/categoryScreen',
    },
    {
      'title': 'Users',
      'image': 'assets/logo/users_logo.png',
      'route': '/usersScreen', 
    },
    {
      'title': 'Orders',
      'image': 'assets/logo/order_logo.png',
      'route': '/orderScreen', 
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _signOut(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,  
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.0, 
          ),
          itemCount: _dashboardItems.length,
          itemBuilder: (ctx, i) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(_dashboardItems[i]['route']);
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      _dashboardItems[i]['image'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      _dashboardItems[i]['title'],
                      style: AppWidget.semiBoldTextfieldsize(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
