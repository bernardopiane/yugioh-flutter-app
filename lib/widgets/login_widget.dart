import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
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

      debugPrint('User logged in: ${userCredential.user!.email}');
      // You can handle the logged-in user as needed
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
      debugPrint('Error: ${e.message}');
    } catch (e) {
      setState(() {
        _error = 'An unexpected error occurred.';
      });
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_error != null)
            Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 16.0),
            ),
          const SizedBox(height: 16.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _loginUser,
                child: const Text('Login'),
              ),
              const SizedBox(width: 24.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/register");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Change the color for Register button
                ),
                child: const Text('Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
