import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/models/card_attributes.dart';
import 'package:yugi_deck/models/card_link_marker.dart';
import 'package:yugi_deck/utils.dart';
import 'package:yugi_deck/widgets/card_grid_view.dart';

class AdvSearch extends StatefulWidget {
  const AdvSearch({Key? key}) : super(key: key);

  @override
  State<AdvSearch> createState() => _AdvSearchState();
}

class _AdvSearchState extends State<AdvSearch> {
  String? raceSelector;

  String? sortSelector;

  String? attributeSelector;

  String? linkMarkerSelector;

  Map<String, String>? query;

  Future<List<CardInfoEntity>>? data;

  ExpandableController expandableController = ExpandableController();

  final GlobalKey dataKey = GlobalKey();

  final GlobalKey<FormFieldState> linkMarkerSelectorKey =
      GlobalKey<FormFieldState>();

  final _formKey = GlobalKey<FormState>();

  //TODO: Seguir formato de busca do MD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advanced Search"),
        actions: [
          IconButton(
              onPressed: () {
                _formKey.currentState?.reset();
              },
              icon: const Icon(Icons.clear))
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ExpandablePanel(
                controller: expandableController,
                header: const Text("Advanced Search"),
                collapsed: Container(),
                expanded: Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            ListTile(
                              title: TextFormField(
                                decoration:
                                const InputDecoration(label: Text("Name")),
                                onChanged: (value) {
                                  queryBuilder("fname", value);
                                },
                              ),
                            ),
                            ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      onChanged: (value) {
                                        if (value != "") {
                                          queryBuilder("atk", value);
                                        } else {
                                          removeQuery("atk");
                                        }
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        label: Text("Atk"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      onChanged: (value) {
                                        queryBuilder("def", value);
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        label: Text("Def"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                onChanged: (value) {
                                  if (value != "") {
                                    queryBuilder("level", value);
                                  } else {
                                    removeQuery("level");
                                  }
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  label: Text("Level"),
                                ),
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                onTap: () {},
                                //TODO: add race enum
                                decoration: const InputDecoration(
                                  label: Text("Race"),
                                ),
                              ),
                            ),
                            ListTile(
                              title: const Text("Attribute"),
                              subtitle: DropdownButtonFormField<String>(
                                hint: const Text("Attribute"),
                                elevation: 16,
                                style: const TextStyle(color: Colors.deepPurple),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    attributeSelector = newValue!;
                                  });
                                  queryBuilder("attribute", newValue!);
                                },
                                items: attributes
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      onChanged: (value) {
                                        queryBuilder("link", value);
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        label: Text("Link"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ListTile(
                                      // title: const Text("Link marker"),
                                      subtitle: DropdownButtonFormField<String>(
                                        key: linkMarkerSelectorKey,
                                        hint: const Text("Link marker"),
                                        // value: linkMarkerSelector,
                                        elevation: 16,
                                        style:
                                        const TextStyle(color: Colors.deepPurple),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            linkMarkerSelector = newValue!;
                                          });
                                          queryBuilder("linkmarker", newValue!);
                                        },
                                        items: linkMarker
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                onChanged: (value) {
                                  queryBuilder("scale", value);
                                },
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: const InputDecoration(
                                  label: Text("Scale"),
                                ),
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                onChanged: (value) {
                                  queryBuilder("cardset", value);
                                },
                                decoration: const InputDecoration(
                                  label: Text("Cardset"),
                                ),
                              ),
                            ),
                            _buildArchetype(),
                            ListTile(
                              title: TextFormField(
                                onChanged: (value) {
                                  queryBuilder("archetype", value);
                                },
                                decoration: const InputDecoration(
                                  label: Text("Archetype"),
                                ),
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                onTap: () {},
                                //TODO: add banlist enum
                                decoration: const InputDecoration(
                                  label: Text("Banlist"),
                                ),
                              ),
                            ),
                            ListTile(
                              title: const Text("Sort Order"),
                              subtitle: DropdownButtonFormField<String>(
                                hint: const Text("Sort order"),
                                elevation: 16,
                                style: const TextStyle(color: Colors.deepPurple),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    sortSelector = newValue!;
                                  });
                                  queryBuilder("sort", newValue!);
                                },
                                items: <String>[
                                  'Atk',
                                  'Def',
                                  'Name',
                                  'Type',
                                  'Level',
                                  'Id',
                                  'New'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            ListTile(
                              title: ElevatedButton(
                                onPressed: () {
                                  handleSearch();
                                  expandableController.toggle();
                                },
                                child: const Text("Search"),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              if (data != null && !expandableController.expanded)
                FutureBuilder<List<CardInfoEntity>>(
                  future: data,
                  key: dataKey,
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width,
                          child: CardGridView(cardList: snapshot.data!));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
            ],
          ),

          // child: Column(
          //   children: [
          //     Form(
          //         key: _formKey,
          //         child: Column(
          //           children: [
          //             ListTile(
          //               title: TextFormField(
          //                 decoration:
          //                     const InputDecoration(label: Text("Name")),
          //                 onChanged: (value) {
          //                   queryBuilder("fname", value);
          //                 },
          //               ),
          //             ),
          //             ListTile(
          //               title: Row(
          //                 children: [
          //                   Expanded(
          //                     child: TextFormField(
          //                       onChanged: (value) {
          //                         if (value != "") {
          //                           queryBuilder("atk", value);
          //                         } else {
          //                           removeQuery("atk");
          //                         }
          //                       },
          //                       keyboardType: TextInputType.number,
          //                       decoration: const InputDecoration(
          //                         label: Text("Atk"),
          //                       ),
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     width: 16,
          //                   ),
          //                   Expanded(
          //                     child: TextFormField(
          //                       onChanged: (value) {
          //                         queryBuilder("def", value);
          //                       },
          //                       keyboardType: TextInputType.number,
          //                       decoration: const InputDecoration(
          //                         label: Text("Def"),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             ListTile(
          //               title: TextFormField(
          //                 onChanged: (value) {
          //                   if (value != "") {
          //                     queryBuilder("level", value);
          //                   } else {
          //                     removeQuery("level");
          //                   }
          //                 },
          //                 keyboardType: TextInputType.number,
          //                 decoration: const InputDecoration(
          //                   label: Text("Level"),
          //                 ),
          //               ),
          //             ),
          //             ListTile(
          //               title: TextFormField(
          //                 onTap: () {},
          //                 //TODO: add race enum
          //                 decoration: const InputDecoration(
          //                   label: Text("Race"),
          //                 ),
          //               ),
          //             ),
          //             ListTile(
          //               title: const Text("Attribute"),
          //               subtitle: DropdownButtonFormField<String>(
          //                 hint: const Text("Attribute"),
          //                 elevation: 16,
          //                 style: const TextStyle(color: Colors.deepPurple),
          //                 onChanged: (String? newValue) {
          //                   setState(() {
          //                     attributeSelector = newValue!;
          //                   });
          //                   queryBuilder("attribute", newValue!);
          //                 },
          //                 items: attributes
          //                     .map<DropdownMenuItem<String>>((String value) {
          //                   return DropdownMenuItem<String>(
          //                     value: value,
          //                     child: Text(value),
          //                   );
          //                 }).toList(),
          //               ),
          //             ),
          //             ListTile(
          //               title: Row(
          //                 children: [
          //                   Expanded(
          //                     child: TextFormField(
          //                       onChanged: (value) {
          //                         queryBuilder("link", value);
          //                       },
          //                       keyboardType: TextInputType.number,
          //                       decoration: const InputDecoration(
          //                         label: Text("Link"),
          //                       ),
          //                     ),
          //                   ),
          //                   const SizedBox(width: 8),
          //                   Expanded(
          //                     child: ListTile(
          //                       // title: const Text("Link marker"),
          //                       subtitle: DropdownButtonFormField<String>(
          //                         key: linkMarkerSelectorKey,
          //                         hint: const Text("Link marker"),
          //                         // value: linkMarkerSelector,
          //                         elevation: 16,
          //                         style:
          //                             const TextStyle(color: Colors.deepPurple),
          //                         onChanged: (String? newValue) {
          //                           setState(() {
          //                             linkMarkerSelector = newValue!;
          //                           });
          //                           queryBuilder("linkmarker", newValue!);
          //                         },
          //                         items: linkMarker
          //                             .map<DropdownMenuItem<String>>(
          //                                 (String value) {
          //                           return DropdownMenuItem<String>(
          //                             value: value,
          //                             child: Text(value),
          //                           );
          //                         }).toList(),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             ListTile(
          //               title: TextFormField(
          //                 onChanged: (value) {
          //                   queryBuilder("scale", value);
          //                 },
          //                 keyboardType: TextInputType.number,
          //                 maxLength: 1,
          //                 decoration: const InputDecoration(
          //                   label: Text("Scale"),
          //                 ),
          //               ),
          //             ),
          //             ListTile(
          //               title: TextFormField(
          //                 onChanged: (value) {
          //                   queryBuilder("cardset", value);
          //                 },
          //                 decoration: const InputDecoration(
          //                   label: Text("Cardset"),
          //                 ),
          //               ),
          //             ),
          //             _buildArchetype(),
          //             ListTile(
          //               title: TextFormField(
          //                 onChanged: (value) {
          //                   queryBuilder("archetype", value);
          //                 },
          //                 decoration: const InputDecoration(
          //                   label: Text("Archetype"),
          //                 ),
          //               ),
          //             ),
          //             ListTile(
          //               title: TextFormField(
          //                 onTap: () {},
          //                 //TODO: add banlist enum
          //                 decoration: const InputDecoration(
          //                   label: Text("Banlist"),
          //                 ),
          //               ),
          //             ),
          //             ListTile(
          //               title: const Text("Sort Order"),
          //               subtitle: DropdownButtonFormField<String>(
          //                 hint: const Text("Sort order"),
          //                 elevation: 16,
          //                 style: const TextStyle(color: Colors.deepPurple),
          //                 onChanged: (String? newValue) {
          //                   setState(() {
          //                     sortSelector = newValue!;
          //                   });
          //                   queryBuilder("sort", newValue!);
          //                 },
          //                 items: <String>[
          //                   'Atk',
          //                   'Def',
          //                   'Name',
          //                   'Type',
          //                   'Level',
          //                   'Id',
          //                   'New'
          //                 ].map<DropdownMenuItem<String>>((String value) {
          //                   return DropdownMenuItem<String>(
          //                     value: value,
          //                     child: Text(value),
          //                   );
          //                 }).toList(),
          //               ),
          //             ),
          //             ListTile(
          //               title: ElevatedButton(
          //                 onPressed: () {
          //                   handleSearch();
          //                   Scrollable.ensureVisible(dataKey.currentContext!);
          //                 },
          //                 child: const Text("Search"),
          //               ),
          //             ),
          //           ],
          //         )),
          //     if (data != null)
          //       FutureBuilder<List<CardInfoEntity>>(
          //         future: data,
          //         key: dataKey,
          //         initialData: const [],
          //         builder: (context, snapshot) {
          //           if (snapshot.hasData) {
          //             return SizedBox(
          //                 height: MediaQuery.of(context).size.height * 0.6,
          //                 width: MediaQuery.of(context).size.width,
          //                 child: CardGridView(cardList: snapshot.data!));
          //           } else {
          //             return const CircularProgressIndicator();
          //           }
          //         },
          //       ),
          //   ],
          // ),
        ),
      ),
    );
  }

  _buildArchetype() {
    //TODO Implement fetching archetypes from https://db.ygoprodeck.com/api/v7/archetypes.php
    return const SizedBox();
  }

  void queryBuilder(String queryField, String queryText) {
    query ??= <String, String>{};

    query?[queryField] = queryText;
  }

  // Future<List> handleSearch() async {
  //
  //
  //   Uri uri = Uri(
  //       scheme: "https",
  //       host: "db.ygoprodeck.com",
  //       path: "/api/v7/cardinfo.php",
  //       queryParameters: query);
  //
  //   debugPrint("URI : ${uri.toString()}");
  //
  //   var response = await http.post(uri);
  //
  //   var json = jsonDecode(response.body);
  //
  //   var lista = json["data"] as List;
  //
  //   return lista;
  //
  //   debugPrint(lista.toString());
  // }

  // Future<List<CardInfoEntity>> handleSearch() async {
  void handleSearch() async {
    Uri uri = Uri(
        scheme: "https",
        host: "db.ygoprodeck.com",
        path: "/api/v7/cardinfo.php",
        queryParameters: query);

    // var response = await http.post(uri);

    setState(() {
      data = fetchCardList(uri.toString(), context);
    });
    //
    // List<CardInfoEntity> cardList = [];
    //
    // var json = jsonDecode(response.body);
    //
    // if (json["error"] != null) {
    //   var snackBar = SnackBar(
    //     content: Text(json["error"].toString()),
    //   );
    //   snackbarKey.currentState?.showSnackBar(snackBar);
    //   // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   return cardList;
    // }
    //
    // var lista = json["data"] as List;
    //
    // for (var element in lista) {
    //   CardInfoEntity cardInfo = CardInfoEntity.fromJson(element);
    //   cardList.add(cardInfo);
    // }
    //
    // return cardList;
  }

  void removeQuery(String s) {
    query?.remove(s);
  }
}
