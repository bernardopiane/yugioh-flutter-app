import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yugi_deck/models/card_v2.dart';

import 'deck.dart';

class DeckListGetX extends GetxController {
  DeckListGetX();

  DeckListGetX.withDeck(this.decks);

  RxList<Deck> decks = <Deck>[].obs;

  addDeck(deck) {
    decks.add(deck);
    saveToFile(deck);
  }

  renameDeck(Deck deck, String newName) {
    Deck curDeck = decks.firstWhere((element) => deck.id == element.id);
    curDeck.name = newName;
    saveToFile(deck);
  }

  setCards(Deck deck, List<CardV2> cards) {
    Deck curDeck = decks.firstWhere((element) => deck.id == element.id);
    curDeck.cards = cards;
    curDeck.sortDeck();
  }

  setExtra(Deck deck, List<CardV2> cards) {
    Deck curDeck = decks.firstWhere((element) => deck.id == element.id);
    curDeck.extra = cards;
    curDeck.sortDeck();
  }

  Future<void> saveToFile(Deck deck) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/decks/${deck.id}');
    await file.writeAsString(jsonEncode(deck));
  }

  Future<void> loadFromFile(BuildContext context) async {
    decks.clear();
    final directory = await getApplicationDocumentsDirectory();
    Directory("${directory.path}/decks").exists().then((directoryExists) {
      if (!directoryExists) {
        Directory("${directory.path}/decks")
            .create()
            .then((value) => debugPrint("Directory created"));
      } else {
        debugPrint("Directory exists");
      }
    });

    final deckDir = Directory("${directory.path}/decks");
    deckDir.list().forEach((element) {
      if (element.isAbsolute) {
        // File file = File(element.path);
        final File file = File(element.path);
        file.readAsString().then((value) {
          var json = jsonDecode(value);
          Deck deck = Deck.withId(json['name'], json['id']);
          List<CardV2> cardList = [];
          List<CardV2> extraList = [];
          if (json['cards'] != null && json['cards'].isNotEmpty) {
            json['cards'].forEach((element) {
              CardV2 card = CardV2.fromJson(element);
              cardList.add(card);
            });
            deck.setCards(cardList);
          }
          if (json['extra'] != null && json['extra'].isNotEmpty) {
            json['extra'].forEach((element) {
              CardV2 card = CardV2.fromJson(element);
              extraList.add(card);
            });
            deck.setExtra(extraList);
          }
          decks.add(deck);
        });
      }
    });
  }

  deleteDeck(String id) async {
    final directory = await getApplicationDocumentsDirectory();
    Directory("${directory.path}/decks").exists().then((directoryExists) {
      if (!directoryExists) {
        Directory("${directory.path}/decks")
            .create()
            .then((value) => debugPrint("Directory created"));
      }
    });

    debugPrint(id.toString());

    final deckDir = Directory("${directory.path}/decks");
    File file = File("${deckDir.path}/$id");
    file.delete();
    decks.removeWhere((element) => element.id == id);

    //   TODO Delete from firestore
  }

  Deck getDeckById(String id) {
    Deck deck = decks.firstWhere((element) => element.id == id);
    return deck;
  }
}
