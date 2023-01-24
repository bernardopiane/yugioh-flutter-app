import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/utils.dart';

import '../generated/json/base/json_field.dart';

@JsonSerializable()
class Deck {
  String? id;
  String name;
  String? description;

  // List<CardInDeck>? cards;
  List<CardV2>? cards;
  List<CardV2>? extra;


  Deck.withId(this.name, this.id);

  Deck(this.name) {
    id = DateTime
        .now()
        .millisecondsSinceEpoch.toString();
  }

  Map toJson() => {
    'name': name,
    'cards': cards,
    'extra': extra,
    'id': id,
  };

  int getCardsLength() {
    int len = 0;
    for (var card in cards!) {
      if (!isExtraDeck(card)) {
        len++;
      }
    }
    return len;
  }

  int getExtraLength() {
    int len = 0;
    for (var card in cards!) {
      if (isExtraDeck(card)) {
        len++;
      }
    }
    return len;
  }

  setDescription(String desc) {
    description = desc;
  }

  addCard(CardV2 card) {
    // CardInDeck cardInDeck = CardInDeck(card);
    // if(cards.contains(cardInDeck)){
    //   cards.firstWhere((element) => element == cardInDeck).quantity = ;
    // }
    if(cards!.length <= 60){
      cards!.add(card);
    }
  }

  setCards(List<CardV2> cardList) {
    cards = cardList;
  }

  addExtra(CardV2 card) {
    if (extra!.length <= 15) {
      extra!.add(card);
    } else {
      //  TODO Display msg to user
    }
  }

  setExtra(List<CardV2> cardList) {
    extra = cardList;
  }

  removeCard(CardV2 card) {
    // CardInDeck cardInDeck = CardInDeck(card);
    cards!.remove(card);
  }

  removeExtra(CardV2 card) {
    // CardInDeck cardInDeck = CardInDeck(card);
    extra!.remove(card);
  }

  rename(String newName){
    name = newName;
  }
}


