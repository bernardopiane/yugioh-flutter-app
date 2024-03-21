import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInWidget extends StatefulWidget {
  const GoogleSignInWidget({super.key});

  @override
  GoogleSignInWidgetState createState() => GoogleSignInWidgetState();
}

class GoogleSignInWidgetState extends State<GoogleSignInWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isSigningIn = false; // New variable to handle sign-in process state

  Future<User?> _handleSignIn() async {
    setState(() {
      isSigningIn = true;
    });

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        // idToken: googleSignInAuthentication.idToken,
      //   Google services latest has ID Token problems on android
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      setState(() {
        isSigningIn = false; // Update state after sign-in process finishes
      });

      return authResult.user;
    } catch (error) {
      debugPrint('Error during Google sign-in: $error');
      setState(() {
        isSigningIn = false; // Update state to allow button press on error
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !isSigningIn
          ? _handleSignIn
          : null, // Disable button if sign-in in progress
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: isSigningIn
          ? const CircularProgressIndicator()
          : const Text(
              'Sign In with Google',
              style: TextStyle(fontSize: 16.0),
            ), // Show a spinner while signing in
    );
  }
}
