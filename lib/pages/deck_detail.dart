import 'dart:collection';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/models/deck.dart';
import 'package:yugi_deck/models/deck_list.dart';
import 'package:yugi_deck/utils.dart';
import 'package:yugi_deck/variables.dart';
import 'package:yugi_deck/widgets/card_width_slider.dart';
import 'package:yugi_deck/widgets/my_card.dart';

class DeckDetail extends StatefulWidget {
  const DeckDetail({Key? key, required this.deck}) : super(key: key);
  final Deck deck;

  @override
  State<DeckDetail> createState() => _DeckDetailState();
}

class _DeckDetailState extends State<DeckDetail> {
  late final SharedPreferences prefs;

  late Future<List<CardInfoEntity>> data;

  List<CardInfoEntity> deckCards = [];

  String? inputCardName;

  double cardWidth = 100;

  bool deleteView = false;

  HashSet selectedCards = HashSet();

  bool hasChanged = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => setState((){
      prefs = value;
      if(prefs.getDouble("cardWidth") != null){
        cardWidth = prefs.getDouble("cardWidth")!;
      }
    }));
    setState(() {
      data = fetchCardList(
          "https://db.ygoprodeck.com/api/v7/cardinfo.php?staple=yes", context);
      if (widget.deck.cards != null) {
        deckCards = widget.deck.cards!;
      }
    });
    //  Load from local file if exists
  }

  Future<bool> _onWillPop() async {
    if (!hasChanged) {
      Navigator.of(context).pop(true);
      return false;
    }
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to save the changes'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  _saveDeck();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: deleteView
            ? AppBar(
                title: Text("Selected: ${selectedCards.length}"),
                actions: [
                  IconButton(
                    onPressed: () {
                      toggleDeleteView();
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                  IconButton(
                    onPressed: () {
                      handleDeleteCards();
                      toggleDeleteView();
                    },
                    icon: const Icon(Icons.delete_forever),
                  ),
                ],
              )
            : AppBar(
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
                        hasChanged = false;
                      },
                      icon: const Icon(Icons.save)),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return CardWidthSlider(
                              notifyParent: changeWidth,
                              currentWidth: cardWidth,
                            );
                          });
                    },
                    icon: const Icon(Icons.photo_size_select_large),
                  ),
                  IconButton(
                    onPressed: () {
                      toggleDeleteView();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
        body: SafeArea(
          minimum: const EdgeInsets.all(8),
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: cardWidth,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: cardAspRatio,
            ),
            children: _buildCards(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCards() {
    List<Widget> widgets = [];

    for (var element in deckCards) {
      if (deleteView) {
        if (selectedCards.contains(element)) {
          widgets.add(
            Stack(
              children: [
                MyCard(
                  cardInfo: element,
                  fullImage: true,
                  noTap: true,
                ),
                Material(
                  color: Colors.grey.withOpacity(0.60),
                  child: InkWell(
                    onTap: () {
                      handleSelectedCards(element);
                    },
                  ),
                ),
                Positioned(
                  top: -10,
                  right: -10,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          );
        } else {
          widgets.add(
            Stack(
              children: [
                MyCard(
                  cardInfo: element,
                  fullImage: true,
                  noTap: true,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      handleSelectedCards(element);
                    },
                  ),
                ),
                Positioned(
                  top: -10,
                  right: -10,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      deleteCard(element);
                    },
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        widgets.add(MyCard(
          cardInfo: element,
          fullImage: true,
        ));
      }
    }

    return widgets;
  }

  void handleSelectedCards(CardInfoEntity element) {
    if (selectedCards.contains(element)) {
      setState(() {
        selectedCards.remove(element);
        hasChanged = true;
      });
    } else {
      setState(() {
        selectedCards.add(element);
        hasChanged = true;
      });
    }
  }

  void _openSearchCardDialog(BuildContext context) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                debugPrint("Portrait");
                return SingleChildScrollView(
                  child: AlertDialog(
                    insetPadding: const EdgeInsets.all(8),
                    title: TextFormField(
                      onFieldSubmitted: (value) {
                        _searchAPI();
                      },
                      onChanged: (value) {
                        setState(() {
                          inputCardName = value.toString();
                        });
                      },
                      decoration:
                          const InputDecoration(label: Text("Search...")),
                    ),
                    content: SizedBox(
                        height: MediaQuery.of(context).size.height - 240,
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder<List<CardInfoEntity>>(
                          future: data,
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              return GridView(
                                  key: Key(deckCards.length.toString()),
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: cardAspRatio,
                                  ),
                                  children:
                                      _buildSearchResults(snapshot.data!));
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        )),
                    actions: [
                      SizedBox(
                        height: 32,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Ok"),
                        ),
                      ),
                    ],
                    // actions: [
                    //   TextButton(
                    //       onPressed: () {
                    //         Navigator.of(context).pop();
                    //       },
                    //       child: const Text("Ok"))
                    // ],
                  ),
                );
              } else {
                debugPrint("Landscape");
                return SingleChildScrollView(
                  child: AlertDialog(
                    insetPadding: const EdgeInsets.all(8),
                    content: Column(
                      children: [
                        TextFormField(
                          onFieldSubmitted: (value) {
                            _searchAPI();
                          },
                          onChanged: (value) {
                            setState(() {
                              inputCardName = value.toString();
                            });
                          },
                          decoration:
                              const InputDecoration(label: Text("Search...")),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: FutureBuilder<List<CardInfoEntity>>(
                                future: data,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    return GridView(
                                        key: Key(deckCards.length.toString()),
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          mainAxisSpacing: 12,
                                          crossAxisSpacing: 12,
                                          childAspectRatio: cardAspRatio,
                                        ),
                                        children: _buildSearchResults(
                                            snapshot.data!));
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 32,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Ok"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // actions: [
                    //   TextButton(
                    //       onPressed: () {
                    //         Navigator.of(context).pop();
                    //       },
                    //       child: const Text("Ok"))
                    // ],
                  ),
                );
              }
            },
          );
        });
  }

  addToState(CardInfoEntity element) {
    setState(() {
      deckCards.add(element);
      deckCards.sort((a, b) => a.name!.compareTo(b.name!));
      hasChanged = true;
    });
  }

  List<Widget> _buildSearchResults(List<CardInfoEntity> cardList) {
    List<Widget> widgets = [];

    for (var element in cardList) {
      int howManyInDeck =
          deckCards.where((card) => element.id == card.id).length;
      widgets.add(
        StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                var quantity = deckCards.where((card) => card.id == element.id);

                // if (exists.id == null) {
                if (quantity.length <= 2) {
                  addToState(element);
                  setState(() {
                    howManyInDeck++;
                  });
                } else {
                  //TODO:  Display  feedback to user
                }
              },
              child: GridTile(
                child: Stack(
                  children: [
                    MyCard(
                      cardInfo: element,
                      noTap: true,
                    ),
                    if (deckCards
                        .where((card) => card.id == element.id)
                        .isNotEmpty)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Badge(
                          badgeContent: Text(deckCards
                              .where((card) => element.id == card.id)
                              .length
                              .toString()),
                        ),
                      )
                  ],
                ),
              ),
            );
          },
          // child: GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   onTap: () {
          //     var quantity = deckCards.where((card) => card.id == element.id);
          //
          //     // if (exists.id == null) {
          //     if (quantity.length <= 2) {
          //       setState(() {
          //         // if (!selectedCards.contains(element)) {
          //         deckCards.add(element);
          //         hasChanged = true;
          //         // }
          //       });
          //     } else {
          //       //TODO:  Display  feedback to user
          //     }
          //   },
          //   child: GridTile(
          //     child: Stack(
          //       children: [
          //         MyCard(
          //           cardInfo: element,
          //           noTap: true,
          //         ),
          //         if (deckCards.where((card) => card.id == element.id).isNotEmpty)
          //           Positioned(
          //             top: 0,
          //             right: 0,
          //             child: Badge(
          //               badgeContent: Text(deckCards
          //                   .where((card) => element.id == card.id)
          //                   .length
          //                   .toString()),
          //             ),
          //           )
          //       ],
          //     ),
          //   ),
          // ),
        ),
      );
    }
    return widgets;
  }

  void _searchAPI() {
    setState(() {
      data = fetchCardList(
          "https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=$inputCardName",
          context);
    });
  }

  void _saveDeck() {
    // Provider.of<DeckList>(context, listen: false).decks.add(widget.deck);
    Provider.of<DeckList>(context, listen: false)
        .setCards(widget.deck, deckCards);
    Provider.of<DeckList>(context, listen: false).saveToFile();
    //TODO Fix double saving
    // final directory = await getApplicationDocumentsDirectory();
    // debugPrint("Dir: ${directory.toString()}");
    // final File file = File('${directory.path}/decks/${widget.deck.name}.txt');
    // await file.writeAsString(jsonEncode(selectedCards));
    // file.readAsString().then((value) => debugPrint(value));
  }

  void changeWidth(double value) {
    setState(() {
      cardWidth = value;
    });
  }

  void toggleDeleteView() {
    setState(() {
      deleteView = !deleteView;
    });
  }

  void handleDeleteCards() {
    for (var element in selectedCards) {
      setState(() {
        deleteCard(element);
      });
    }
  }

  void deleteCard(CardInfoEntity card) {
    setState(() {
      deckCards.remove(card);
      hasChanged = true;
    });
  }
}
