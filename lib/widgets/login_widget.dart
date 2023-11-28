import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _error;

  Future<void> _loginUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      print('User logged in: ${userCredential.user!.email}');
      // You can handle the logged-in user as needed
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
      print('Error: ${e.message}');
    } catch (e) {
      setState(() {
        _error = 'An unexpected error occurred.';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: Colors.red),
          ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.0),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 24.0),
        ElevatedButton(
          onPressed: _loginUser,
          child: Text('Login'),
        ),
      ],
    );
  }
}
