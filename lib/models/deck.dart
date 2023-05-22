import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/utils.dart';

import '../generated/json/base/json_field.dart';

@JsonSerializable()
class Deck {
  String? id;
  String name;
  String? description;

  List<CardV2>? cards;
  List<CardV2>? extra;

  Deck.withId(this.name, this.id);

  Deck(this.name) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
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

  void addCard(CardV2 card) {
    if (isExtraDeck(card)) {
      if (extra!.length >= 15) {
        throw Exception('Extra deck can have a maximum of 15 cards');
      }
      if (hasThreeCopies(extra!, card)) {
        throw Exception('Deck already contains 3 copies of the card');
      }
      extra!.add(card);
    } else {
      if (cards!.length >= 60) {
        throw Exception('Deck can have a maximum of 60 cards');
      }
      if (hasThreeCopies(cards!, card)) {
        throw Exception('Deck already contains 3 copies of the card');
      }
      cards!.add(card);
    }
  }

  setCards(List<CardV2> cardList) {
    cards = cardList;
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

  rename(String newName) {
    name = newName;
  }

  bool hasThreeCopies(List<CardV2> array, CardV2 card) {
    // Filter the array based on the ID
    List<CardV2> filtered =
        array.where((element) => element.id == card.id).toList();

    // Check if the filtered result has at least 3 copies
    return filtered.length >= 3;
  }

  sortDeck() {
    // cards?.sort(compareCards);
    cards?.sort((a, b) {
      // First, sort by type (monster > spell > trap)
      if (a.type!.contains("Monster") && !b.type!.contains("Monster")) {
        return -1;
      } else if (a.type!.contains("Spell") && b.type!.contains("Trap")) {
        return -1;
      } else if (a.type!.contains("Spell") && b.type!.contains("Monster")) {
        return 1;
      } else if (a.type!.contains("Trap") && !b.type!.contains("Trap")) {
        return 1;
      }

      // Then, sort by name
      return a.name!.compareTo(b.name!);
    });
  }
}
