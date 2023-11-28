import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutWidget extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logoutUser(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate back to the login page or any other desired page after logout
      if (!context.mounted) return;
      // Handles warning for using context on async blocs
      Navigator.pushReplacementNamed(
          context, '/login'); // Replace with your login route
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _logoutUser(context),
          child: const Text('Log Out'),
        ),
      ],
    );
  }
}
