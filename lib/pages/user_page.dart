import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/database.dart';
import 'package:yugi_deck/models/deck.dart';
import 'package:yugi_deck/models/deck_list.dart';
import 'package:yugi_deck/pages/login_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    List<Deck> deck = Provider.of<DeckList>(context).decks;

    // TODO ask to login if not authed, keep track as a Provider

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Page"),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text("Login Page"),
            ),
            // Display User Profile Picture
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("user.profilePicture"),
            ),
            const SizedBox(height: 16),

            // Display User Name
            const Text(
              "user.name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Display List of Deck Names
            const Text(
              'Decks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Last saved: "),
            const SizedBox(height: 16),
            Text("Decks saved: ${deck.length}"),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: deck.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(deck[index].name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
