import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String errorMsg = "";

  Future<void> _registerAndLoginUser() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // User registration successful
      debugPrint('User registered: ${userCredential.user!.email}');

      // Automatically log in the user after registration
      UserCredential loginCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Perform navigation after successful login
      _navigateToUserPage(loginCredential.user != null);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          errorMsg = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMsg = 'The account already exists for that email.';
        } else {
          errorMsg = 'Error: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        errorMsg = 'Error: $e';
      });
    }
  }

  void _navigateToUserPage(bool loginSuccess) {
    if (loginSuccess) {
      // Use Navigator to perform navigation
      Navigator.pushReplacementNamed(
          context, '/login'); // Replace with your user page route
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (errorMsg.isNotEmpty)
              Text(errorMsg, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _registerAndLoginUser,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
              ),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
