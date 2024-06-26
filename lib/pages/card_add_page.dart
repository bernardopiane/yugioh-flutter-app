import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/models/filter_options.dart';
import 'package:yugi_deck/pages/filter_page.dart';
import 'package:yugi_deck/utils.dart';
import 'package:yugi_deck/widgets/app_bar_search.dart';
import 'package:yugi_deck/widgets/my_card.dart';
import 'package:badges/badges.dart' as badges;

import '../data.dart';
import '../models/deck.dart';
import '../variables.dart';

class CardAddPage extends StatefulWidget {
  const CardAddPage({Key? key, required this.deck, required this.addCard})
      : super(key: key);
  final Deck deck;
  final Function addCard;

  @override
  CardAddPageState createState() => CardAddPageState();
}

class CardAddPageState extends State<CardAddPage> {
  Future<List<CardV2>> cardResult = Future<List<CardV2>>.value([]);

  FilterOptions activeFilters = FilterOptions();

  final TextEditingController _controller = TextEditingController();
  bool isFiltered = false;

  final DataProvider dataProvider = Get.put(DataProvider());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: AppBarSearch(
            searchController: _controller,
            search: _searchQuery,
            clear: _clearSearch),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(FilterPage(
                    applyFilter: applyFilter, activeFilters: activeFilters));
              },
              icon: const Icon(Icons.filter))
        ],
      ),
      body: FutureBuilder<List<CardV2>>(
        future: cardResult,
        builder: (BuildContext context, AsyncSnapshot<List<CardV2>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is still loading
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there was an error while fetching the data
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If the future completed successfully, but there is no data
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: Icon(
                  Icons.warning,
                  size: 64,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            // If the future completed successfully and data is available
            List<CardV2> cardList = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: cardAspRatio,
              ),
              itemCount: cardList.length,
              itemBuilder: (BuildContext ctx, index) {
                int quantity = 0;
                if (isExtraDeck(cardList[index])) {
                  quantity = widget.deck.extra
                          ?.where((card) => cardList[index].id == card.id)
                          .length ??
                      0;
                } else {
                  quantity = widget.deck.cards
                          ?.where((card) => cardList[index].id == card.id)
                          .length ??
                      0;
                }
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        try {
                          widget.addCard(cardList[index]);
                        } catch (e) {
                          debugPrint("Error: ${e.toString()}");
                        } finally {
                          setState(() {
                            quantity++;
                          });
                        }
                      },
                      onLongPress: () {
                        // TODO: Navigate to card page
                      },
                      child: MyCard(
                        cardInfo: cardList[index],
                        noTap: true,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: badges.Badge(
                        badgeContent: Text(quantity.toString()),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  _searchQuery(String query, {bool withFilter = false}) async {
    if (isFiltered) {
      List<CardV2> cards = await cardResult;
      debugPrint("isFiltered");
      List<CardV2> filtered = await searchCards(cards, query);
      setState(() {
        cardResult = convertToFuture(filtered);
      });
    } else {
      setState(() {
        cardResult = searchCards(dataProvider.cards, query);
      });
    }
  }

  Future<List<CardV2>> filterCards(FilterOptions filterOptions) {
    setState(() {
      activeFilters = filterOptions;
    });
    List<CardV2> cardList = dataProvider.cards;

    List<CardV2> filtered = cardList.where((card) {
      if (filterOptions.cardTypes.isNotEmpty) {
        List<String> types = card.type?.toUpperCase().split(" ") ?? [];
        if (!filterOptions.cardTypes
            .any((type) => types.contains(type.toUpperCase()))) {
          return false;
        }
      }

      if (filterOptions.attributes.isNotEmpty &&
          !filterOptions.attributes.contains(card.attribute)) {
        return false;
      }

      if (filterOptions.levels.isNotEmpty &&
          !filterOptions.levels.contains(card.level)) {
        return false;
      }

      if (filterOptions.monsterTypes.isNotEmpty &&
          !filterOptions.monsterTypes.contains(card.race!.toUpperCase())) {
        return false;
      }

      if (filterOptions.spellTrapTypes.isNotEmpty) {
        for (var type in filterOptions.spellTrapTypes) {
          String typeName = type.split(" ").elementAt(0);
          String frameType = type.split(" ").elementAt(1);
          String cardFrameType = card.type!.split(" ").elementAt(0);
          //Match card type
          if (frameType.toUpperCase() != cardFrameType.toUpperCase()) {
            return false;
          }
          //Match card name
          if (typeName.toUpperCase() != card.race!.toUpperCase()) {
            return false;
          }
        }
      }

      return true;
    }).toList();

    return convertToFuture(filtered);
  }

  void applyFilter(FilterOptions filterOptions) {
    // Only apply if FilterOptions is not default
    if (!filterOptions.isDefaultFilter()) {
      Future<List<CardV2>> cardList = filterCards(filterOptions);
      setState(() {
        isFiltered = true;
        cardResult = cardList;
      });
    } else {
      List<CardV2> allCards = dataProvider.cards;
      setState(() {
        isFiltered = false;
        cardResult = convertToFuture(allCards);
      });
    }
  }

  _clearSearch() {
    _controller.clear();
    setState(() {
      isFiltered = false;
      activeFilters = FilterOptions();
      cardResult = convertToFuture(dataProvider.cards);
    });
  }
}
