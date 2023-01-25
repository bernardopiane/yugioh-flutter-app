import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yugi_deck/models/card_v2.dart';
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

  late Future<List<CardV2>> data;

  List<CardV2> deckCards = [];
  List<CardV2> extraCards = [];

  String? inputCardName;

  double cardWidth = 100;

  bool deleteView = false;

  bool hasChanged = false;

  int howManyInDeck = 0;

  //TODO Only replace cards if user saves the deck
  //Currently it saves after every card removed

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => setState(() {
          prefs = value;
          if (prefs.getDouble("cardWidth") != null) {
            cardWidth = prefs.getDouble("cardWidth")!;
          }
        }));
    setState(() {
      data = fetchCardList(
          "https://db.ygoprodeck.com/api/v7/cardinfo.php?staple=yes", context);
      if (widget.deck.cards != null) {
        deckCards = widget.deck.cards!;
      }
      if (widget.deck.extra != null) {
        extraCards = widget.deck.extra!;
      }
    });
    //  Load from local file if exists
  }

  Future<bool> _onWillPop() async {
    if (!hasChanged && !deleteView) {
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
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          bottomNavigationBar: Material(
            color: Theme.of(context).bottomAppBarColor,
            elevation: 2,
            child: TabBar(
              labelColor: Theme.of(context).textTheme.bodyMedium?.color,
              tabs: [
                Tab(
                  child: Text("Normal - ${deckCards.length.toString()}"),
                ),
                Tab(
                  child: Text("Extra - ${extraCards.length.toString()}"),
                ),
              ],
            ),
          ),
          appBar: deleteView
              ? AppBar(
                  title: const Text("Remove card(s)"),
                  actions: [
                    IconButton(
                      onPressed: () {
                        toggleDeleteView();
                      },
                      icon: const Icon(Icons.check),
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
          body: TabBarView(
            children: [
              SafeArea(
                minimum: const EdgeInsets.all(8),
                child: GridView.builder(
                    itemCount: deckCards.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: cardWidth,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: cardAspRatio,
                    ),
                    itemBuilder: (BuildContext ctx, index) {
                      //TODO fix selecting all same name cards BEFORE saving
                      //TODO remove multiselect, keep only single
                      if (deleteView) {
                        return Stack(
                          children: [
                            MyCard(
                              cardInfo: deckCards.elementAt(index),
                              fullImage: true,
                              noTap: true,
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    deleteCard(deckCards.elementAt(index));
                                  },
                                  backgroundColor: Colors.red,
                                  mini: true,
                                  child: const Icon(Icons.close),
                                )),
                          ],
                        );
                      } else {
                        return MyCard(
                          cardInfo: deckCards.elementAt(index),
                          fullImage: true,
                        );
                      }
                    }),
              ),
              SafeArea(
                minimum: const EdgeInsets.all(8),
                child: GridView.builder(
                    itemCount: extraCards.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: cardWidth,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: cardAspRatio,
                    ),
                    itemBuilder: (BuildContext ctx, index) {
                      if (deleteView) {
                        return Stack(
                          children: [
                            MyCard(
                              cardInfo: extraCards.elementAt(index),
                              fullImage: true,
                              noTap: true,
                            ),
                            // Material(
                            //   color: Colors.transparent,
                            //   child: InkWell(
                            //     onTap: () {
                            //       handleSelectedCards(
                            //           extraCards.elementAt(index));
                            //     },
                            //   ),
                            // ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    deleteCard(extraCards.elementAt(index));
                                  },
                                  backgroundColor: Colors.red,
                                  mini: true,
                                  child: const Icon(Icons.close),
                                )),
                          ],
                        );
                      } else {
                        return MyCard(
                          cardInfo: extraCards.elementAt(index),
                          fullImage: true,
                        );
                      }
                    }),
                // child: GridView(
                //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                //     maxCrossAxisExtent: cardWidth,
                //     mainAxisSpacing: 12,
                //     crossAxisSpacing: 12,
                //     childAspectRatio: cardAspRatio,
                //   ),
                //   children: _buildExtra(),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // List<Widget> _buildCards() {
  //   List<Widget> widgets = [];
  //
  //   for (var element in deckCards) {
  //     if (deleteView) {
  //       if (selectedCards.contains(element)) {
  //         widgets.add(
  //           Stack(
  //             children: [
  //               MyCard(
  //                 cardInfo: element,
  //                 fullImage: true,
  //                 noTap: true,
  //               ),
  //               Material(
  //                 color: Colors.grey.withOpacity(0.60),
  //                 child: InkWell(
  //                   onTap: () {
  //                     handleSelectedCards(element);
  //                   },
  //                 ),
  //               ),
  //               Positioned(
  //                 top: -10,
  //                 right: -10,
  //                 child: IconButton(
  //                   icon: const Icon(Icons.remove_circle_outline),
  //                   onPressed: () {},
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       } else {
  //         widgets.add(
  //           Stack(
  //             children: [
  //               MyCard(
  //                 cardInfo: element,
  //                 fullImage: true,
  //                 noTap: true,
  //               ),
  //               Material(
  //                 color: Colors.transparent,
  //                 child: InkWell(
  //                   onTap: () {
  //                     handleSelectedCards(element);
  //                   },
  //                 ),
  //               ),
  //               Positioned(
  //                   top: 0,
  //                   right: 0,
  //                   child: FloatingActionButton(
  //                     onPressed: () {
  //                       deleteCard(element);
  //                     },
  //                     backgroundColor: Colors.red,
  //                     mini: true,
  //                     child: const Icon(Icons.close),
  //                   )),
  //             ],
  //           ),
  //         );
  //       }
  //     } else {
  //       widgets.add(MyCard(
  //         cardInfo: element,
  //         fullImage: true,
  //       ));
  //     }
  //   }
  //
  //   return widgets;
  // }

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
                        child: FutureBuilder<List<CardV2>>(
                          future: data,
                          builder: (context, snapshot) {
                            Widget child;
                            if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              child = GridView(
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
                              child = const SizedBox(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 225),
                                child: child,
                              ),
                            );
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
                              child: FutureBuilder<List<CardV2>>(
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

  addToState(CardV2 element) {
    //TODO: Check if api returns extra deck type - remove hardcoded
    if (isExtraDeck(element)) {
      if (extraCards.length <= 15) {
        setState(() {
          extraCards.add(element);
          extraCards.sort((a, b) => a.name!.compareTo(b.name!));
          hasChanged = true;
        });
        _saveDeck();
      }
    } else {
      if (deckCards.length <= 60) {
        setState(() {
          deckCards.add(element);
          deckCards.sort((a, b) => a.name!.compareTo(b.name!));
          hasChanged = true;
        });
        _saveDeck();
      }
    }
  }

  List<Widget> _buildSearchResults(List<CardV2> cardList) {
    List<Widget> widgets = [];

    for (var element in cardList) {
      if (isExtraDeck(element)) {
        howManyInDeck =
            extraCards.where((card) => element.id == card.id).length;
      } else {
        howManyInDeck = deckCards.where((card) => element.id == card.id).length;
      }
      widgets.add(
        StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Iterable<CardV2> quantity;
                if (isExtraDeck(element)) {
                  quantity = extraCards.where((card) => card.id == element.id);
                } else {
                  quantity = deckCards.where((card) => card.id == element.id);
                }
                // if (exists.id == null) {
                if (quantity.length <= 2) {
                  if (isExtraDeck(element)) {
                    if (isBelowDeckLimit(extraCards, true)) {
                      addToState(element);
                      setState(() {
                        howManyInDeck++;
                      });
                    }
                  } else {
                    if (isBelowDeckLimit(deckCards, false)) {
                      addToState(element);
                      setState(() {
                        howManyInDeck++;
                      });
                    }
                  }
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
                      ),
                    if (extraCards
                        .where((card) => card.id == element.id)
                        .isNotEmpty)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Badge(
                          badgeContent: Text(extraCards
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
    Provider.of<DeckList>(context, listen: false)
        .setExtra(widget.deck, extraCards);
    Provider.of<DeckList>(context, listen: false).saveToFile(widget.deck);
    hasChanged = false;
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

  void deleteCard(CardV2 card) {
    if (isExtraDeck(card)) {
      setState(() {
        extraCards.remove(card);
        hasChanged = true;
      });
      _saveDeck();
    } else {
      setState(() {
        deckCards.remove(card);
        hasChanged = true;
      });
      _saveDeck();
    }
  }

  // _buildExtra() {
  //   List<Widget> widgets = [];
  //
  //   //TODO create proper extra deck display
  //   for (var element in extraCards) {
  //     if (deleteView) {
  //       if (selectedCards.contains(element)) {
  //         widgets.add(
  //           Stack(
  //             children: [
  //               MyCard(
  //                 cardInfo: element,
  //                 fullImage: true,
  //                 noTap: true,
  //               ),
  //               Material(
  //                 color: Colors.grey.withOpacity(0.60),
  //                 child: InkWell(
  //                   onTap: () {
  //                     handleSelectedCards(element);
  //                   },
  //                 ),
  //               ),
  //               Positioned(
  //                 top: -10,
  //                 right: -10,
  //                 child: IconButton(
  //                   icon: const Icon(Icons.remove_circle_outline),
  //                   onPressed: () {},
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       } else {
  //         widgets.add(
  //           Stack(
  //             children: [
  //               MyCard(
  //                 cardInfo: element,
  //                 fullImage: true,
  //                 noTap: true,
  //               ),
  //               Material(
  //                 color: Colors.transparent,
  //                 child: InkWell(
  //                   onTap: () {
  //                     handleSelectedCards(element);
  //                   },
  //                 ),
  //               ),
  //               Positioned(
  //                 top: -10,
  //                 right: -10,
  //                 child: IconButton(
  //                   icon: const Icon(Icons.remove_circle_outline),
  //                   onPressed: () {
  //                     deleteCard(element);
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     } else {
  //       widgets.add(MyCard(
  //         cardInfo: element,
  //         fullImage: true,
  //       ));
  //     }
  //   }
  //
  //   return widgets;
  // }
}
