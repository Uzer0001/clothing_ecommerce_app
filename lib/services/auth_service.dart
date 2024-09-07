import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream to listen to authentication state changes
  Stream<User?> get currentUserChanges => _firebaseAuth.authStateChanges();

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      print('Error signing in with email and password: $e');
      return false;
    }
  }

  // Register a new user with email and password
  Future<bool> registerWithEmailAndPassword(
    {required String email, required String password, required String role}) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
      });

      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut(); // Sign out from Google as well
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Check if the current user is an admin
  Future<bool> isAdmin() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        return data != null && data['role'] == 'admin';
      }
    }
    return false;
  }
  // Sign in with Google (Mobile)
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Check if the user has a role in Firestore
      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (!doc.exists) {
        // Initialize user data in Firestore if not present
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'role': 'user', // Default role for Google sign-in
        });
      }
      return true;
    } catch (e) {
      print('Error signing in with Google: $e');
      return false;
    }
  }

  // Register a new user with Google
  Future<bool> registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Check if the user has a role in Firestore
      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (!doc.exists) {
        // Initialize user data in Firestore if not present
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'role': 'user', // Default role for Google sign-in
        });
      }
      return true;
    } catch (e) {
      print('Error registering with Google: $e');
      return false;
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error sending password reset email: $e');
      rethrow;
    }
  }
}
