import 'package:flutter/material.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/widgets/search_filter.dart';
import '../utils.dart';
import '../widgets/card_grid_view.dart';

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
        child: SearchFilter(search: _advSearch),
      ),
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              autofocus: false,
              //TODO stop autofocus on navigation pop
              controller: searchController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
              onEditingComplete: () {
                _search(searchController.value.text);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _scaffoldkey.currentState!.openEndDrawer();
              },
              icon: const Icon(Icons.filter_list))
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: FutureBuilder<List<CardV2>>(
          future: data,
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.connectionState != ConnectionState.done) {
              child = SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              child = const Text("Failed to load data");
            } else if (snapshot.hasData) {
              child = CardGridView(cardList: snapshot.data!);
              // return GridView(
              //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //     maxCrossAxisExtent: 200,
              //     mainAxisSpacing: 12,
              //     crossAxisSpacing: 12,
              //     childAspectRatio: 59 / 86,
              //   ),
              //   children: _buildList(snapshot.data!),
              // );
            } else {
              child = const CircularProgressIndicator();
            }

            return Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 225),
                child: child,
              ),
            );
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
    setState(() {
      data = fetchCardList(
          "https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=$value",
          context);
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  _advSearch(Map<String, String>? query) {
    Uri uri = Uri(
        scheme: "https",
        host: "db.ygoprodeck.com",
        path: "/api/v7/cardinfo.php",
        queryParameters: query);

    // var response = await http.post(uri);

    setState(() {
      data = fetchCardList(uri.toString(), context);
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
