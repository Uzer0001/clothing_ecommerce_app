import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  static AuthController instance = Get.find();
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Observables
  var user = Rxn<User>();
  var isLoading = false.obs;
  var role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_firebaseAuth.authStateChanges());
    ever(user, _initialFetchUserRole); // Fetch role whenever user changes
  }

  Future<void> _initialFetchUserRole(User? firebaseUser) async {
    if (firebaseUser != null) {
      await fetchUserRole(firebaseUser.uid);
    }
  }

  Future<void> fetchUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        role.value = doc['role'] ?? '';
      } else {
        role.value = 'user'; // Default role if none found
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      isLoading(true);
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword(String email, String password, String role) async {
    try {
      isLoading(true);
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
      });

      this.role.value = role; // Set role in observable
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      isLoading(true);
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      role.value = ''; // Clear role on sign out
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading(true);
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      DocumentSnapshot doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (!doc.exists) {
        // Initialize user data in Firestore if not present
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'role': 'user',
        });
      }
      await fetchUserRole(userCredential.user!.uid);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email sent', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Check if the current user is an admin
  bool isAdmin() {
    return role.value == 'admin';
  }
}
