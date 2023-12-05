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

  Future<User?> _handleSignIn() async {
    try {
      // Trigger Google sign-in process
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain GoogleSignInAuthentication for Firebase
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Authenticate with Firebase using GoogleSignInAuthentication
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      // Return the authenticated user
      return authResult.user;
    } catch (error) {
      debugPrint('Error during Google sign-in: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        User? user = await _handleSignIn();
        if (user != null) {
          // Handle successful sign-in, for example, navigate to the user's page
          debugPrint('Google sign-in successful. User: ${user.displayName}');
        } else {
          // Handle unsuccessful sign-in
          debugPrint('Google sign-in unsuccessful.');
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text(
        'Sign In with Google',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
