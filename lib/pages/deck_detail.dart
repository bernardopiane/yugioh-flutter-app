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
import 'package:yugi_deck/pages/card_add_page.dart';

import '../globals.dart';

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
            color: const BottomAppBarTheme().color,
            elevation: 2,
            child: TabBar(
              labelColor: Theme.of(context).textTheme.bodyMedium?.color,
              tabs: [
                Tab(
                  child: Text("Main - ${deckCards.length.toString()}"),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CardAddPage(
                                      deck: widget.deck,
                                      addCard: _addCard,
                                    )),
                          );
                          // _openSearchCardDialog(context);
                        },
                        icon: const Icon(Icons.add)),
                    IconButton(
                        onPressed: () {
                          if (deckCards.length < 40) {
                            var snackBar = const SnackBar(
                              content: Text("Your deck has less than 40 cards"),
                            );
                            snackbarKey.currentState?.showSnackBar(snackBar);
                          }
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

  void _saveDeck() async {
    final deckListProvider = Provider.of<DeckList>(context, listen: false);

    deckListProvider.setCards(widget.deck, deckCards);
    deckListProvider.setExtra(widget.deck, extraCards);
    await deckListProvider.saveToFile(widget.deck);

    hasChanged = false;
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

  void _addCard(CardV2 card) {
    try {
      if (widget.deck != null) {
        setState(() {
          widget.deck!.addCard(card);
        });
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      SnackBar snackBar = SnackBar(
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return; // Add a return statement here to exit the method
    } finally {
      if (widget.deck != null) {
        widget.deck!.sortDeck();
      }
      hasChanged = true;
    }
  }
}
