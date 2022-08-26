import 'package:flutter/material.dart';
import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/widgets/my_card.dart';

class CardGridView extends StatelessWidget {
  const CardGridView({Key? key, required this.cardList}) : super(key: key);
  final List<CardInfoEntity> cardList;

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 59 / 86,
      ),
      children: _buildList(cardList),
    );
  }

  List<Widget> _buildList(List<CardInfoEntity> data) {
    List<Widget> widgets = [];

    for (var element in data) {
      widgets.add(GridTile(child: MyCard(cardInfo: element)));
    }

    return widgets;
  }
}
