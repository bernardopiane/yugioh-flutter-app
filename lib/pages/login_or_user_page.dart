import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/models/deck_list.dart';
import 'package:yugi_deck/widgets/google_sign_in_widget.dart';
import 'package:yugi_deck/widgets/login_widget.dart';

import '../database.dart';
import '../widgets/logout_widget.dart';

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
        title: const Text("Login"),
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
              return const LoginUser();
            }
          }

          // Handle loading state if needed
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final User user;

  const UserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Welcome, ${user.email}!',
            style: Theme.of(context).textTheme.titleLarge),
        LogoutWidget(),
        // TODO remove testing buttons
        ElevatedButton(
          onPressed: () {
            saveToDatabase(context);
          },
          child: const Text("Save to DB"),
        ),
        ElevatedButton(
          onPressed: () {
            handleUserLogin(Provider.of<DeckList>(context, listen: false));
          },
          child: const Text("Load from DB"),
        )
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
        Text(
          'Please log in to continue.',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const LoginWidget(),
        const SizedBox(height: 16),
        const GoogleSignInWidget(),
      ],
    );
  }
}

//TODO Create proper User Page, with image options