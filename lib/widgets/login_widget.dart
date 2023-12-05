import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_error != null)
          Text(
            _error!,
            style: const TextStyle(color: Colors.red),
          ),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 24.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _loginUser,
              child: const Text('Login'),
            ),
            const SizedBox(width: 24.0,),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, "/register");
              },
              child: const Text('Register'),
            ),
          ],
        ),

      ],
    );
  }
}
