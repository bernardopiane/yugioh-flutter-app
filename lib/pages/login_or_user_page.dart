import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yugi_deck/widgets/login_widget.dart';

class LoginOrUserPage extends StatefulWidget {
  const LoginOrUserPage({super.key});

  @override
  State<LoginOrUserPage> createState() => LoginOrUserPageState();
}

class LoginOrUserPageState extends State<LoginOrUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;

            if (user != null) {
              // User is logged in, display UserInfo widget
              return UserInfo(user: user);
            } else {
              // User is not logged in, display LoginUser widget
              return LoginUser();
            }
          }

          // Handle loading state if needed
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final User user;

  UserInfo({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Welcome, ${user.email}!'),
        // Add user-specific content here
        LogoutWidget(),
      ],
    );
  }
}

class LoginUser extends StatelessWidget {
  const LoginUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Please log in to continue.'),
        // Add your login UI components here
        LoginWidget(),
      ],
    );
  }
}

class LogoutWidget extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logoutUser(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _logoutUser(context),
      child: Text('Log Out'),
    );
  }
}
