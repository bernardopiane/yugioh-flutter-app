import 'package:yugi_deck/card_info_entity.dart';

class CardInDeck {
  CardInfoEntity? card;
  int? quantity;

  CardInDeck(this.card);

  CardInDeck.multiple(this.card, this.quantity);
}