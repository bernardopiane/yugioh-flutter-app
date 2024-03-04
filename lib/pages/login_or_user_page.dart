import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:yugi_deck/widgets/google_sign_in_widget.dart';
import 'package:yugi_deck/widgets/login_widget.dart';

import '../database.dart';
import '../models/deck_list_getx.dart';
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
      body: Center(
        child: StreamBuilder<User?>(
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
      ),
    );
  }
}

class UserInfo extends StatefulWidget {
  final User user;

  const UserInfo({super.key, required this.user});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  int databaseDeckQuantity = 0;

  @override
  void initState() {
    // TODO: implement initState
    fetchDeckQuantity(context).then((value){
      setState(() {
        databaseDeckQuantity = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Welcome, ${widget.user.email}!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Expanded(
          child: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,
            // Generate 100 widgets that display their index in the List.
            children: [
              Card(
                child: Center(
                    child: Text(
                  "You have ${Provider.of<DeckList>(context, listen: false).decks.length} decks saved in app",
                  textAlign: TextAlign.center,
                )),
              ),
              Card(
                child: Center(
                    child: Text(
                  "You have $databaseDeckQuantity decks saved in the cloud",
                  textAlign: TextAlign.center,
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LogoutWidget(),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            saveToDatabase(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.background,
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: const Text("Save to DB"),
        ),
        ElevatedButton(
          onPressed: () {
            final DeckListGetX deckListGetX = Get.find<DeckListGetX>();

            handleUserLogin(deckListGetX);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.background,
            textStyle: const TextStyle(fontSize: 16),
          ),
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
