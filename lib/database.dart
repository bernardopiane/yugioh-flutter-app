import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/models/deck_list.dart';

import 'models/deck.dart';

Future<void> saveToDatabase(BuildContext context) async {
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<Deck> deckList = Provider.of<DeckList>(context, listen: false).decks;

    // Ensure the user is authenticated before proceeding
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      debugPrint('User not authenticated. Cannot save to the database.');
      return;
    }

    // Reference to the 'user_deck' collection
    CollectionReference userDeckCollection = firestore.collection('users');

    // Serialize the deckList to JSON
    String deckListJson = jsonEncode(deckList);

    // Add data to Firestore
    await userDeckCollection.doc(currentUser.uid).set({
      'user_id': currentUser.uid,
      'deck_list': deckListJson,
      'email': currentUser.email,
      // Use server time instead of client
      'last_updated': FieldValue.serverTimestamp(),
    });

    debugPrint('Data added successfully');
  } catch (error) {
    debugPrint('Failed to add data: $error');
    // Handle the error or throw it to be caught by an upper layer
    rethrow;
  }
}
