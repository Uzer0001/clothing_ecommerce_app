// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/auth/login_screen.dart';

class AppDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppDrawer({super.key});

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'User'),
            accountEmail: Text(user?.email ?? 'Email not available'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {
              // Navigate to categories screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Products'),
            onTap: () {
            //  Navigator.of(context).push(MaterialPageRoute(builder: (builder){
              // return const ProductListScreen();
            //  }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}
