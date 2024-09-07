// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await Provider.of<AuthProvider>(context, listen: false).login(email, password);
      } else {
        await Provider.of<AuthProvider>(context, listen: false).signUp(email, password);
      }
    } catch (error) {
      // Handle errors
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authenticate')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Login' : 'Sign Up'),
              ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(_isLogin ? 'Create new account' : 'I already have an account'),
            ),
          ],
        ),
      ),
    );
  }
}