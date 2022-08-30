import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/models/deck.dart';
import 'package:yugi_deck/utils.dart';
import 'package:yugi_deck/widgets/card_grid_view.dart';
import 'package:yugi_deck/widgets/my_card.dart';

class DeckDetail extends StatefulWidget {
  const DeckDetail({Key? key, required this.deck}) : super(key: key);
  final Deck deck;

  @override
  State<DeckDetail> createState() => _DeckDetailState();
}

class _DeckDetailState extends State<DeckDetail> {
  late Future<List<CardInfoEntity>> data;

  List<CardInfoEntity> selectedCards = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      data = fetchCardList(
          "https://db.ygoprodeck.com/api/v7/cardinfo.php?name=Tornado%20Dragon",
          context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
        actions: [
          IconButton(
              onPressed: () {
                _openSearchCardDialog(context);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 59 / 86,
        ),
        children: _buildCards(),
      ),
    );
  }

  List<Widget> _buildCards() {
    List<Widget> widgets = [];

    widget.deck.cards?.forEach((element) {
      widgets.add(MyCard(cardInfo: element.card!));
    });

    for (var element in selectedCards) {
      widgets.add(ListTile(title: MyCard(cardInfo: element)));
    }

    return widgets;
  }

  void _openSearchCardDialog(BuildContext context) {
    debugPrint("Search Dialog Open");
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Pick a card"),
            content: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<List<CardInfoEntity>>(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      debugPrint(snapshot.data.toString());
                      return GridView(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 59 / 86,
                          ),
                          children: _buildSearchResults(snapshot.data!));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("add"))
            ],
          );
        });
  }

  List<Widget> _buildSearchResults(List<CardInfoEntity> list) {
    List<Widget> widgets = [];

    for (var element in list) {
      widgets.add(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            debugPrint("Tapped");
            setState(() {
              if (!selectedCards.contains(element)) {
                selectedCards.add(element);
              }
            });
          },
          child: GridTile(
            child: MyCard(
              cardInfo: element,
              noTap: true,
            ),
          ),
        ),
      );
    }

    debugPrint(data.toString());

    return widgets;
  }
}
