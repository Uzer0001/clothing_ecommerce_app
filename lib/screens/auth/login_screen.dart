// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  var _isObscured = true;

  

 

  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        bool success =
            await _authService.signInWithEmailAndPassword(_email, _password);
        if (success) {
          bool isAdmin = await _authService.isAdmin();
          if (isAdmin) {
            Navigator.pushReplacementNamed(context, '/adminDashboard');
          } else {
            Navigator.pushReplacementNamed(context, '/navigation');
          }
        } else {
          setState(() {});
        }
        // Navigator.of(context).pushReplacementNamed('/home');
      } on FirebaseAuthException catch (e) {
        print(e.message);
         
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(e.message ?? 'Failed to sign in with email'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _isObscured = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 56.0,
            left: 24.0,
            bottom: 24.0,
            right: 24.0,
          ),
          child: Column(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(image: AssetImage("assets/logo/logo.jpg")),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        labelText: "E-mail",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _email = value;
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          padding: const EdgeInsetsDirectional.only(end: 12.0),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                          icon: _isObscured
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _password = value;
                      },
                    ),
                    const SizedBox(
                      height: 16.0 / 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed("/forgotpassword");
                            },
                            child: const Text("Forgot Password?"))
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () {
                                _signInWithEmailAndPassword();
                              },
                              child: const Text("Login"),
                            ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register');
                        },
                        child: const Text("Create Account"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
