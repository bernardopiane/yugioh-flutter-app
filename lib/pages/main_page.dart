import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/data.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/widgets/theme_notifier.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

  String searchTerm = "";

  TextEditingController searchController = TextEditingController();

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
      key: _scaffoldkey,
      endDrawer: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).dialogBackgroundColor,
        child: FilterPage(
            applyFilter: applyFilter,
            activeFilters: activeFilters)
      ),
      appBar: AppBar(
        title:
            AppBarSearch(searchController: searchController, search: _search, clear: _clearSearch,),
        actions: [
          IconButton(
              onPressed: () {
                _scaffoldkey.currentState!.openEndDrawer();
              },
              icon: const Icon(Icons.filter_list)),
          Consumer<ThemeNotifier>(builder: (context, themeNotifier, _) {
            return Switch(
              value: themeNotifier.currentTheme == ThemeMode.dark,
              onChanged: (value) {
                themeNotifier.toggleTheme(); // Toggle the theme
              },
            );
          }),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: FutureBuilder<List<CardV2>>(
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
            //

            // if (snapshot.connectionState != ConnectionState.done) {
            //   child = SizedBox(
            //     height: MediaQuery.of(context).size.height,
            //     width: MediaQuery.of(context).size.width,
            //     child: const Center(
            //       child: CircularProgressIndicator(),
            //     ),
            //   );
            // }
            // if (snapshot.hasError) {
            //   debugPrint(snapshot.error.toString());
            //   child = const Text("Failed to load data");
            // } else if (snapshot.hasData) {
            //   child = CardGridView(cardList: snapshot.data!);
            //   // return GridView(
            //   //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            //   //     maxCrossAxisExtent: 200,
            //   //     mainAxisSpacing: 12,
            //   //     crossAxisSpacing: 12,
            //   //     childAspectRatio: 59 / 86,
            //   //   ),
            //   //   children: _buildList(snapshot.data!),
            //   // );
            // } else {
            //   child = const CircularProgressIndicator();
            // }
            //
            // return Center(
            //   child: AnimatedSwitcher(
            //     duration: const Duration(milliseconds: 225),
            //     child: child,
            //   ),
            // );
          },
        ),
      ),
    );
  }

  // List<Widget> _buildList(List<CardInfoEntity> data) {
  //   List<Widget> widgets = [];
  //
  //   for (var element in data) {
  //     widgets.add(GridTile(child: MyCard(cardInfo: element)));
  //   }
  //
  //   return widgets;
  // }

  _search(String value) {
    // var url =
    //     Uri.parse("https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=$value");
    // setState(() {
    //   data = fetchCardList(
    //       "https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=$value",
    //       context);
    // });
    setState(() {
      data = searchCards(
          Provider.of<DataProvider>(context, listen: false).cards, value);
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  _clearSearch() {
    setState(() {
      activeFilters = FilterOptions();
      data = convertToFuture(Provider.of<DataProvider>(context, listen: false).cards);
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
      List<CardV2> allCards = Provider.of<DataProvider>(context, listen: false).cards;
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
    List<CardV2> cardList =
        Provider.of<DataProvider>(context, listen: false).cards;

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
