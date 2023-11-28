import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/models/deck_list.dart';

import 'models/deck.dart';

Future<void> saveToDatabase(BuildContext context) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

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
  CollectionReference userDeckCollection = firestore.collection('user_deck');

  // Add data to Firestore
  try {
    await userDeckCollection.doc("Bernardo").set({
      'user_id': 'Bernardo', //TODO Use user id from AUTH
      'deck_list': jsonEncode(deckList),
      //   TODO experiment with saving only card ID;
    });

    print('Data added successfully');
  } catch (error) {
    print('Failed to add data: $error');
  }
}
