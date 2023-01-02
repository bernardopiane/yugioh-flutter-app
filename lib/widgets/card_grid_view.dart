import 'package:flutter/material.dart';
import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/models/cardV2.dart';
import 'package:yugi_deck/variables.dart';
import 'package:yugi_deck/widgets/my_card.dart';

class CardGridView extends StatelessWidget {
  const CardGridView({Key? key, required this.cardList}) : super(key: key);
  final List<CardV2> cardList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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

  List<Widget> _buildList(List<CardV2> data) {
    List<Widget> widgets = [];

    for (var element in data) {
      widgets.add(GridTile(child: MyCard(cardInfo: element)));
    }

    return widgets;
  }
}
