import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Page"),
      ),
      body: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            addToDB();
          },
          child: const Text('Add Data to Firestore'),
        ),
      ),
    );
  }

  addToDB() {
    Map<String, dynamic> data = {
      'user_id': 'John Doe',
      'user_decks': {'deck_content': "DECK JSON AQUI"},
    };

    db.collection("user_deck").add(data).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }
}
