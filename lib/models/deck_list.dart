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

  setCards(Deck deck, List<CardInfoEntity> cards){
    Deck curDeck = decks.firstWhere((element) => deck.name == element.name);
    curDeck.cards = cards;
    notifyListeners();
  }

  setExtra(Deck deck, List<CardInfoEntity> cards){
    Deck curDeck = decks.firstWhere((element) => deck.name == element.name);
    curDeck.extra = cards;
    notifyListeners();
  }

  saveToFile() async {
    //  Iterate over the deck list and saveToFile
    for (var deck in decks) {
      final directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/decks/${deck.name}');
      List<CardInfoEntity> cards = deck.cards!;
      cards.addAll(deck.extra!);
      await file.writeAsString(jsonEncode(cards));
    //TODO Fix saving extra cards to normal
    }
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
          Deck deck = Deck(basename(file.path));
          List<CardInfoEntity> cardList = [];
          List<CardInfoEntity> extraList = [];
          if(json != null) {
            json.forEach((element) {
              CardInfoEntity card = CardInfoEntity.fromJson(element);
              debugPrint("Carta: ${card.name} : ${card.type}");
              if(isExtraDeck(card)){
                extraList.add(card);
              } else {
                cardList.add(card);
              }
            });
            deck.setCards(cardList);
            deck.setExtra(extraList);
          }
          decks.add(deck);
        });
      }
    });
    notifyListeners();
  }
}
