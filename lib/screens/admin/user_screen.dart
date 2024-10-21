import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  // Fetch users from Firestore
  Stream<QuerySnapshot> _fetchUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchUsers(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching users.'));
          }

          final userDocs = snapshot.data?.docs;

          if (userDocs == null || userDocs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (ctx, index) {
              var userDoc = userDocs[index];
              var userData = userDoc.data() as Map<String, dynamic>; // Safely cast to Map

              var userName = userData['userName'] ?? 'No name';
              var userEmail = userData['email'] ?? 'No email';
              var userRole = userData['role'] ?? 'User';
              var userProfileImage = userData['profileImage'] ?? '';

              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: userProfileImage.isNotEmpty
                      ? NetworkImage(userProfileImage)
                      : const AssetImage('assets/images/placeholder.jpg') as ImageProvider,
                  onBackgroundImageError: (_, __) {
                    // If there's an error loading the network image, you can handle it here
                    // This ensures that even if NetworkImage fails, the UI won't crash.
                  },
                ),
                title: Text(userName),
                subtitle: Text(userEmail),
                trailing: Text(userRole),
              );
            },
          );
        },
      ),
    );
  }
}
