import 'package:clothing_app/screens/order_screen/all_order_screen.dart';
import 'package:clothing_app/screens/profile_screen/edit_profile/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

    String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _profileImageUrl = userDoc['profileImage']; // Fetching the profileImage URL from Firestore
          });
        }
      } catch (e) {
        print("Failed to load user profile: $e");
      }
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const SizedBox(height: 60,),
          CircleAvatar(
            radius: 70,
            backgroundImage: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                  ? NetworkImage(_profileImageUrl!) // Load image from Firebase
                  : const AssetImage('assets/logo/logo.jpg') as ImageProvider, // Fallback to default image
          ),
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              Get.to(()=>const EditProfileScreen());
            },
            child:  iconProfile('Profile', CupertinoIcons.person),
          ),
         
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              Get.to(()=> const AllOrderScreen());
            },
            child:  iconProfile('Order', CupertinoIcons.cube_box),
          ),
          const SizedBox(height: 30,),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){_signOut(context);},style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)), child: const Text("Logout"),)),
        ],),
      ),
    );
  }

  iconProfile(String title,IconData iconData){
    return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow:[ BoxShadow(
                offset: const Offset(0, 5),
                color: Colors.deepOrange.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10,
              )]
            ),
            child: ListTile(
              title: Text(title),
              
              leading: Icon(iconData),
              trailing: const Icon(Icons.arrow_forward,color: Colors.grey,),
              tileColor: Colors.white,
            ),
          );

  }
}