import 'package:flutter/material.dart';
import 'package:yugi_deck/card_info_entity.dart';
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

  late Future<List<CardInfoEntity>> data;

  String searchTerm = "";

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    data =
        fetchCardList("https://db.ygoprodeck.com/api/v7/cardinfo.php", context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: FutureBuilder<List<CardInfoEntity>>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return const Text("Failed to load data");
            } else if (snapshot.hasData) {
              return CardGridView(cardList: snapshot.data!);
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
              return const CircularProgressIndicator();
            }
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
  }
}
