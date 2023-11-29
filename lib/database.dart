import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/models/deck_list.dart';

import 'models/deck.dart';

Future<void> saveToDatabase(BuildContext context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Deck> deckList = Provider.of<DeckList>(context, listen: false).decks;

  // Map<String, dynamic> data = {
  //   'user_id': 'Bernardo', //Use user id from AUTH
  //   'user_decks': {jsonEncode(deckList)},
  // };
  //
  // db.collection("user_deck").add(data).then((DocumentReference doc) =>
  //     debugPrint('DocumentSnapshot added with ID: ${doc.id}'));

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Reference to the 'user_deck' collection
  CollectionReference userDeckCollection = firestore.collection('users');

  // Add data to Firestore
  try {
    await userDeckCollection.doc(_auth.currentUser?.uid).set({
      'user_id': _auth.currentUser?.uid,
      'deck_list': jsonEncode(deckList),
      "email": _auth.currentUser?.email,
      "last_updated": DateTime.now()
    });

    debugPrint('Data added successfully');
  } catch (error) {
    debugPrint('Failed to add data: $error');
  }
}
