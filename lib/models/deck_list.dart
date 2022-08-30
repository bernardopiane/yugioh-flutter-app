import 'package:flutter/material.dart';

import 'deck.dart';

class DeckList extends ChangeNotifier{
  DeckList(this.decks);

  List<Deck> decks = [];

  addDeck(deck){
    decks.add(deck);
    notifyListeners();
  }
}