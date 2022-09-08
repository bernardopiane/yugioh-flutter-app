import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/card_info_entity.dart';

import 'deck.dart';

class DeckList extends ChangeNotifier {
  DeckList(this.decks);

  List<Deck> decks = [];

  addDeck(deck) {
    decks.add(deck);
    notifyListeners();
  }

  setCards(Deck deck, List<CardInfoEntity> cards){
  //  TODO find deck and set cards
    Deck curDeck = decks.firstWhere((element) => deck.name == element.name);
    curDeck.cards = cards;
  }

  saveToFile() async {
    //  Iterate over the deck list and saveToFile
    //  TODO: save data to disk
    debugPrint("saveToFile");
    for (var deck in decks) {
      final directory = await getApplicationDocumentsDirectory();
      debugPrint("Deck name: ${deck.name}");
      final File file = File('${directory.path}/decks/${deck.name}');
      debugPrint('Json Encode: ${jsonEncode(deck.cards)}');
      await file.writeAsString(jsonEncode(deck.cards));
    }
    notifyListeners();
  }

  loadFromFile(BuildContext context) async {
    decks = [];
    final directory = await getApplicationDocumentsDirectory();
    //TODO Create directory if not found
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
          Deck deck = Deck(basename(file.path));
          List<CardInfoEntity> cardList = [];
          if(json != null) {
            json.forEach((element) {
              debugPrint("Card: ${element.toString()}");
              CardInfoEntity card = CardInfoEntity.fromJson(element);
              cardList.add(card);
            });
            deck.addMultipleCards(cardList);
          }
          decks.add(deck);
        });
      }
    });
    notifyListeners();
  }
}
