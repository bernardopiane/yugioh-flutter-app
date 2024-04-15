import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/models/deck_list_getx.dart';

import 'models/deck.dart';

Future<void> saveToDatabase(BuildContext context) async {
  DeckListGetX deckListGetX = Get.find<DeckListGetX>();

  try {
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<Deck> deckList = deckListGetX.decks;

    // Ensure the user is authenticated before proceeding
    User? currentUser = auth.currentUser;
    if (currentUser == null) {
      debugPrint('User not authenticated. Cannot save to the database.');
      Get.snackbar("Error", "User not authenticated. Cannot save to the database.");
      return;
    }

    // Reference to the 'user_deck' collection
    CollectionReference usersCollection = firestore.collection('users');

    // Serialize the deckList to JSON
    // String deckListJson = jsonEncode(deckList);

    // Add data to Firestore
    await usersCollection.doc(currentUser.uid).set({
      'user_id': currentUser.uid,
      'email': currentUser.email,
      // Use server time instead of client
    });

    // Create and add decks to User
    DocumentReference userDocRef = usersCollection.doc(currentUser.uid);
    CollectionReference decksCollection = userDocRef.collection('decks');

    // Add data to the sub-collection
    for (final deck in deckList) {
      await decksCollection.doc(deck.id).set(deck.toJson());
    }

    debugPrint('Data added successfully');
  } catch (error) {
    debugPrint('Failed to add data: $error');
    // Handle the error or throw it to be caught by an upper layer
    rethrow;
  }
}

Future<Map<String, dynamic>?> getUserData() async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Fetch user based on currently logged in UID
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data();
      } else {
        // User document does not exist
        return null;
      }
    } else {
      // No user is currently logged in
      return null;
    }
  } catch (e) {
    // TODO Handle any errors during data retrieval
    debugPrint('Error retrieving current user data: $e');
    return null;
  }
}

Future<int> fetchDeckQuantity(BuildContext context) async {
  try {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user == null) {
      debugPrint('No user is signed in');
      return 0;
    }

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final decksCollection = userDocRef.collection('decks');
    final decksQuerySnapshot = await decksCollection.get();

    if (decksQuerySnapshot.docs.isNotEmpty) {
      return decksQuerySnapshot.docs.length;
    }
    return 0;
  } catch (error, stackTrace) {
    debugPrint('Failed to fetch deck quantity: $error\n$stackTrace');
    // Handle the error

    // Return a negative value or throw an exception to indicate failure
    throw Exception('Failed to fetch deck quantity');
  }
}

Future<void> handleUserLogin(DeckListGetX deckListGetX) async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      // No user is signed in
      debugPrint('No user is signed in');
      return;
    }

    // Fetch the user's decks from Firestore
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final decksCollection = userDocRef.collection('decks');
    final decksQuerySnapshot = await decksCollection.get();

    if (decksQuerySnapshot.docs.isNotEmpty) {
      // Convert each document in the 'decks' collection to a Deck object
      List<Deck> deckList = decksQuerySnapshot.docs.map((deckDoc) {
        Map<String, dynamic> deckData = deckDoc.data();
        return Deck.fromJson(deckData);
      }).toList();

      // Do something with the loaded deck data (e.g., update UI or save to local storage)
      for (var deckEntry in deckList) {
        Deck? curDeck = deckListGetX.decks
            .where((element) => element.id == deckEntry.id)
            .firstOrNull;
        if (curDeck != null) {
          if (curDeck.lastUpdated!.isBefore(deckEntry.lastUpdated!)) {
            deckListGetX.addDeck(deckEntry);
          }
        } else {
          deckListGetX.addDeck(deckEntry);
        }
      }
    } else {
      // User has no decks
      debugPrint('User has no decks for user: ${user.uid}');
    }
  } catch (e, stackTrace) {
    // Handle errors (e.g., no internet connection, Firestore not reachable, etc.)
    debugPrint('Error handling user login: $e\n$stackTrace');
  }
  Get.snackbar("Error", "Imported decks from database");
}

List<Deck> getUserDecks(List<dynamic> data) {
  List<Deck> decks = [];
  for (var deckEntry in data) {
    var deckData = deckEntry;

    List<CardV2> cardList = [];
    List<CardV2> extraList = [];
    if (deckData['cards'] != null && deckData['cards'].isNotEmpty) {
      deckData['cards'].forEach((element) {
        CardV2 card = CardV2.fromJson(element);
        cardList.add(card);
      });
    }
    if (deckData['extra'] != null && deckData['extra'].isNotEmpty) {
      deckData['extra'].forEach((element) {
        CardV2 card = CardV2.fromJson(element);
        extraList.add(card);
      });
    }

    debugPrint(deckData.toString());
    Deck deck = Deck.fromDB(deckData["name"], deckData["id"],
        deckData["description"], cardList, extraList, deckData["lastUpdated"]);

    decks.add(deck);
  }

  return decks;
}

Future<void> updateDeckInFirestore(Deck deck) async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      // No user is signed in
      debugPrint('No user is signed in');
      return;
    }
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Reference to a document in the main collection
    DocumentReference userDocRef = usersCollection.doc('user_id');

    // Reference to a subcollection
    CollectionReference decksCollection = userDocRef.collection('decks');

    // Create a map of data to update
    Map<String, dynamic> deckData = {
      'name': deck.name,
      'description': deck.description,
      'cards': deck.cards?.map((card) => card.toJson()).toList(),
      'extra': deck.extra?.map((card) => card.toJson()).toList(),
      'lastUpdated': deck.lastUpdated?.toIso8601String(),
    };

    // Update the document in Firestore based on the deck's ID
    await decksCollection.doc(deck.id).update(deckData);

    // Print a message if needed
    debugPrint('Deck updated successfully in Firestore!');
  } catch (e) {
    // Handle errors (e.g., no internet connection, Firestore not reachable, etc.)
    debugPrint('Error updating deck in Firestore: $e');
    // Handle the error as needed
  }
}
