import 'package:flutter/material.dart';
import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/utils.dart';

import '../widgets/my_card.dart';

class CardSetPage extends StatefulWidget {
  const CardSetPage({Key? key, required this.setName}) : super(key: key);
  final String setName;

  @override
  State<CardSetPage> createState() => _CardSetPageState();
}

class _CardSetPageState extends State<CardSetPage> {
  late Future<List<CardInfoEntity>> data;

  @override
  void initState() {
    super.initState();
    data = fetchCardList(
        "https://db.ygoprodeck.com/api/v7/cardinfo.php?cardset=${widget.setName}",
        context);
  }

  //https://db.ygoprodeck.com/api/v7/cardinfo.php?cardset=metal%20raiders
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Card set: ${widget.setName}"),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: FutureBuilder<List<CardInfoEntity>>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return GridView(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 59 / 86,
                ),
                children: _buildItems(snapshot.data!),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildItems(List<CardInfoEntity>? cards) {
    List<Widget> widgets = [];

    for (var element in cards!) {
      widgets.add(GridTile(child: MyCard(cardInfo: element)));
    }

    return widgets;
  }
}
