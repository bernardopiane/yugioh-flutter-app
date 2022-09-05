import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'deck.dart';

class DeckList extends ChangeNotifier{
  DeckList(this.decks);

  List<Deck> decks = [];

  addDeck(deck){
    decks.add(deck);
    notifyListeners();
  }

  saveToFile() async{
  //  Iterate over the deck list and saveToFile
  //  TODO: save data to disk
    for (var deck in decks) {
      final directory = await getApplicationDocumentsDirectory();
      debugPrint("Dir: ${directory.toString()}");
      final File file = File('${directory.path}/decks/${deck.name}.txt');
      await file.writeAsString(jsonEncode(deck.cards));
      file.readAsString().then((value) => debugPrint(value));
    }
  }
}