import 'package:clothing_app/screens/admin/add_product/add_products.dart';
import 'package:clothing_app/screens/admin/product_screen.dart';
import 'package:clothing_app/screens/auth/forgot_password.dart';
import 'package:clothing_app/screens/auth/registration_screen.dart';
import 'package:clothing_app/widget/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'services/auth_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: 'Clothing Store',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegistrationScreen(),
          '/navigation':(context)=>const NavigationMenu(),
          '/forgotpassword':(context)=>const ForgotPassword(),
          '/home': (context) => const HomeScreen(),
          '/adminDashboard': (context) => const AdminDashboardScreen(),
          '/addProduct':(context)=>const AddProducts(),
          '/productScreen':(context)=>const ProductScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<User?>(
      stream: authService.currentUserChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return FutureBuilder<bool>(
            future: authService.isAdmin(),
            builder: (context, isAdminSnapshot) {
              if (isAdminSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (isAdminSnapshot.hasData && isAdminSnapshot.data == true) {
                return const AdminDashboardScreen();
              } else {
                return const NavigationMenu();
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
    
  }
}