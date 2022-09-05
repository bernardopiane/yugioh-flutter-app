import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/models/card_deck.dart';

class Deck {
  String name;
  String? description;
  // List<CardInDeck>? cards;
  List<CardInfoEntity>? cards;

  Deck(this.name);

  setDescription(String desc){
    description = desc;
  }

  addCard(CardInfoEntity card){
    // CardInDeck cardInDeck = CardInDeck(card);
    // if(cards.contains(cardInDeck)){
    //   cards.firstWhere((element) => element == cardInDeck).quantity = ;
    // }
    cards!.add(card);
  }

  addMultipleCards(List<CardInfoEntity> cardList){
    cards = cardList;
  }

  removeCard(CardInfoEntity card){
    CardInDeck cardInDeck = CardInDeck(card);
    // cards!.remove(cardInDeck);
    cards!.remove(card);
  }

}
