import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/utils.dart';

import 'deck.dart';

class DeckList extends ChangeNotifier {
  DeckList(this.decks);

  List<Deck> decks = [];

  addDeck(deck) {
    decks.add(deck);
    notifyListeners();
  }

  setCards(Deck deck, List<CardInfoEntity> cards) {
    Deck curDeck = decks.firstWhere((element) => deck.name == element.name);
    curDeck.cards = cards;
    notifyListeners();
  }

  setExtra(Deck deck, List<CardInfoEntity> cards) {
    Deck curDeck = decks.firstWhere((element) => deck.name == element.name);
    curDeck.extra = cards;
    notifyListeners();
  }

  saveToFile(Deck deck) async {
    //  Iterate over the deck list and saveToFile
    // for (var deck in decks) {
    //   final directory = await getApplicationDocumentsDirectory();
    //   final File file = File('${directory.path}/decks/${deck.id}');
    //   List<CardInfoEntity> cards = deck.cards!;
    //   cards.addAll(deck.extra!);
    //   await file.writeAsString(jsonEncode(cards));
    // //TODO Fix saving extra cards to normal
    // }

    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/decks/${deck.id}');
    await file.writeAsString(jsonEncode(deck));

    notifyListeners();
  }

  loadFromFile(BuildContext context) async {
    decks = [];
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
          Deck deck = Deck.withId(json['name'], json["id"]);
          List<CardInfoEntity> cardList = [];
          List<CardInfoEntity> extraList = [];
          if (json['cards'] != null || json['cards'].isNotEmpty) {
            json['cards'].forEach((element) {
              CardInfoEntity card = CardInfoEntity.fromJson(element);
              debugPrint("Carta: ${card.name} : ${card.type}");
              cardList.add(card);
            });
            deck.setCards(cardList);
          }
          if (json['extra'] != null || json['extra'].isNotEmpty) {
            json['extra'].forEach((element) {
              CardInfoEntity card = CardInfoEntity.fromJson(element);
              debugPrint("Carta: ${card.name} : ${card.type}");
              extraList.add(card);
            });
            deck.setExtra(extraList);
          }
          decks.add(deck);
        });
      }
    });
    notifyListeners();
  }

  deleteDeck(int id) async {
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
    deckDir.list().forEach((element) {
      debugPrint(element.toString());
    });

    deckDir.exists().then((value) => debugPrint(value.toString()));
  }

}
