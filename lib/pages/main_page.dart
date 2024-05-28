import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yugi_deck/data.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/pages/about_page.dart';
import 'package:yugi_deck/pages/login_or_user_page.dart';
import 'package:yugi_deck/widgets/theme_controller.dart';
import 'package:yugi_deck/widgets/app_bar_search.dart';
import '../models/filter_options.dart';
import '../utils.dart';
import '../widgets/card_grid_view.dart';
import 'filter_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

//TODO change keep alive to Provider for performance

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  FilterOptions activeFilters = FilterOptions();

  bool isFiltered = false;

  late Future<List<CardV2>> data;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TextEditingController searchController = TextEditingController();

  final ThemeController themeController = Get.put(ThemeController());

  final DataProvider dataProvider = Get.put(DataProvider());

  @override
  void initState() {
    super.initState();
    data = fetchCardList(
        "https://db.ygoprodeck.com/api/v7/cardinfo.php?staple=yes&num=15&offset=0",
        context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).dialogBackgroundColor,
          child: FilterPage(
              applyFilter: applyFilter, activeFilters: activeFilters)),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: AppBarSearch(
          pageTitle: "Card List",
          searchController: searchController,
          search: _search,
          clear: _clearSearch,
        ),
        actions: [
          IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
              icon: const Icon(Icons.filter_list)),
          PopupMenuButton<int>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 0,
                child: Text("About"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Toggle Theme"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("Force Refresh"),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text("User Page"),
              ),
            ],
            onSelected: (int value) {
              switch (value) {
                case 0:
                  Get.to(const AboutPage());
                  break;
                case 1:
                  themeController.toggleTheme();
                  break;
                case 2:
                  dataProvider.forceUpdate();
                  break;
                case 3:
                  Get.to(() => const LoginOrUserPage());
                  break;
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CardV2>>(
        future: data,
        builder: (context, snapshot) {
          //
          if (snapshot.connectionState == ConnectionState.none) {
            // If the Future is null or hasn't been initialized, show a loading spinner
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is waiting, show a loading spinner
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            // If the Future is active, show a progress indicator
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is done, display the data
            if (snapshot.hasError) {
              // If there's an error, show the error message
              return Center(child: Text(snapshot.error.toString()));
            }
            // If there's no error, display the data
            return CardGridView(cardList: snapshot.data!);
          }
          return Container(); // unreachable
        },
      ),
    );
  }

  void _search(String value) async {
    try {
      List<CardV2> cardsToSearch;
      if (isFiltered) {
        cardsToSearch = await filterCards(activeFilters);
      } else {
        cardsToSearch = dataProvider.cards;
      }

      setState(() {
        data = searchCards(cardsToSearch, value);
      });
    } catch (error) {
      debugPrint('Error during search: $error');
    } finally {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  _clearSearch() {
    setState(() {
      activeFilters = FilterOptions();
      isFiltered = false;
      data = convertToFuture(dataProvider.cards);
    });
  }

  void applyFilter(FilterOptions filterOptions) {
    // Only apply if FilterOptions is not default
    if (!filterOptions.isDefaultFilter()) {
      Future<List<CardV2>> cardList = filterCards(filterOptions);
      setState(() {
        isFiltered = true;
        data = cardList;
      });
    } else {
      List<CardV2> allCards = dataProvider.cards;
      setState(() {
        isFiltered = false;
        data = convertToFuture(allCards);
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
}
