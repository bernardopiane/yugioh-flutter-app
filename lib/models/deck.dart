import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/globals.dart';
import 'package:yugi_deck/utils.dart';

import '../generated/json/base/json_field.dart';

@JsonSerializable()
class Deck {
  String? id;
  String name;
  String? description;

  // List<CardInDeck>? cards;
  List<CardInfoEntity>? cards;
  List<CardInfoEntity>? extra;


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

  addCard(CardInfoEntity card) {
    // CardInDeck cardInDeck = CardInDeck(card);
    // if(cards.contains(cardInDeck)){
    //   cards.firstWhere((element) => element == cardInDeck).quantity = ;
    // }
    cards!.add(card);
  }

  setCards(List<CardInfoEntity> cardList) {
    cards = cardList;
  }

  addExtra(CardInfoEntity card) {
    if (extra!.length <= 15) {
      extra!.add(card);
    } else {

      //  TODO Display msg to user
    }
  }

  setExtra(List<CardInfoEntity> cardList) {
    extra = cardList;
  }

  removeCard(CardInfoEntity card) {
    // CardInDeck cardInDeck = CardInDeck(card);
    cards!.remove(card);
  }

  removeExtra(CardInfoEntity card) {
    // CardInDeck cardInDeck = CardInDeck(card);
    extra!.remove(card);
  }

  rename(String newName){
    name = newName;
  }
}


