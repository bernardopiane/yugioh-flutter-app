import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/globals.dart';
import 'package:yugi_deck/models/deck.dart';
import 'package:yugi_deck/models/deck_list.dart';
import 'package:yugi_deck/utils.dart';
import 'package:yugi_deck/variables.dart';
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

  String? inputCardName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      data = fetchCardList(
          "https://db.ygoprodeck.com/api/v7/cardinfo.php?name=Tornado%20Dragon",
          context);
    });
  //  Load from local file if exists

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
          IconButton(
              onPressed: () {
                _saveDeck();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: cardAspRatio,
          ),
          children: _buildCards(),
        ),
      ),
    );
  }

  List<Widget> _buildCards() {
    List<Widget> widgets = [];

    widget.deck.cards?.forEach((element) {
      widgets.add(MyCard(cardInfo: element));
    });

    for (var element in selectedCards) {
      widgets.add(MyCard(cardInfo: element));
    }

    return widgets;
  }

  void _openSearchCardDialog(BuildContext context) {
    debugPrint("Search Dialog Open");
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: TextFormField(
              onFieldSubmitted: (value) {
                //  TODO: Search API
                _searchAPI();
              },
              onChanged: (value) {
                setState(() {
                  inputCardName = value.toString();
                });
              },
              decoration: const InputDecoration(label: Text("Search...")),
            ),
            content: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<List<CardInfoEntity>>(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return GridView(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: cardAspRatio,
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

  List<Widget> _buildSearchResults(List<CardInfoEntity> cardList) {
    List<Widget> widgets = [];

    for (var element in cardList) {
      widgets.add(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            debugPrint("Tapped");
            debugPrint(element.toString());

            // //Check if already exists
            // var exists = selectedCards.firstWhere(
            //     (card) => card.id == element.id,
            //     orElse: () => CardInfoEntity());

            var quantity = selectedCards.where((card) => card.id == element.id);

            // if (exists.id == null) {
            if (quantity.length <= 2) {
              setState(() {
                // if (!selectedCards.contains(element)) {
                selectedCards.add(element);
                // }
              });
            } else {
              //TODO:  Display  feedback to user
            }
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

    debugPrint("Build Search Results : ${data.toString()}");

    return widgets;
  }

  void _searchAPI() {
    setState(() {
      data = fetchCardList(
          "https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=$inputCardName",
          context);
    });
  }

  void _saveDeck() async {
    Provider.of<DeckList>(context).decks.add(widget.deck);
    Provider.of<DeckList>(context).saveToFile();
    // final directory = await getApplicationDocumentsDirectory();
    // debugPrint("Dir: ${directory.toString()}");
    // final File file = File('${directory.path}/decks/${widget.deck.name}.txt');
    // await file.writeAsString(jsonEncode(selectedCards));
    // file.readAsString().then((value) => debugPrint(value));
  }
}
