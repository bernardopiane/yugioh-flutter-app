import 'package:flutter/material.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/variables.dart';
import 'package:yugi_deck/widgets/my_card.dart';

class CardGridView extends StatelessWidget {
  const CardGridView({Key? key, required this.cardList}) : super(key: key);
  final List<CardV2> cardList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: cardList.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: cardAspRatio,
        ),
        itemBuilder: (BuildContext ctx, index) {
          return GridTile(
              child: MyCard(
            cardInfo: cardList.elementAt(index),
          ));
        });
  }
}
