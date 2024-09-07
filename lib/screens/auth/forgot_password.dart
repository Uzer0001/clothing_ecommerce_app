import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();

  void _forgotPassword()  {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      _authService.sendPasswordResetEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to $email')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Forgot Password"),
            const SizedBox(height: 16.0),
            const Text("Dont Worry sometime people can forgot , Enter your Email and we will send you password reset link "),
            const SizedBox(height: 32.0*2),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email",prefixIcon: Icon(Icons.account_circle),),
            ),
            const SizedBox(height: 32.0),
            SizedBox(width: double.infinity,child: ElevatedButton(onPressed: (){_forgotPassword();}, child: const Text("Submit")))

          ],
        ),
      ),
    );
  }
}
