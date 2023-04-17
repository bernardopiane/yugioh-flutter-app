import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/models/card_frame_type.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/models/card_attributes.dart';
import 'package:yugi_deck/models/card_banlist.dart';
import 'package:yugi_deck/models/card_link_marker.dart';
import 'package:yugi_deck/models/card_race.dart';
import 'package:yugi_deck/models/card_type.dart';
import 'package:yugi_deck/models/search_tags.dart';
import 'package:yugi_deck/models/sort.dart';
import 'package:yugi_deck/widgets/filter_attributes.dart';
import 'package:yugi_deck/widgets/filter_types.dart';
import 'package:yugi_deck/widgets/dropdown_selector.dart';
import 'package:yugi_deck/widgets/race.dart';

import '../utils.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({Key? key, required this.search}) : super(key: key);

  final Function(Map<String, String>? query) search;
  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter>
    with AutomaticKeepAliveClientMixin<SearchFilter> {
  String? raceSelector;

  List<String> raceFilter = spellRaceList;
  //TODO: implement race filtering & search
  //TODO:

  String? sortSelector;

  String? attributeSelector;

  String? banSelector;

  String? linkMarkerSelector;

  String? frameType;
  //Fixes bug if changing frameType
  GlobalKey<FormFieldState> monsterKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> spellKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> trapKey = GlobalKey<FormFieldState>();

  Map<String, String>? query;

  Future<List<CardV2>>? data;

  final GlobalKey dataKey = GlobalKey();

  final GlobalKey<FormFieldState> linkMarkerSelectorKey =
      GlobalKey<FormFieldState>();

  final _formKey = GlobalKey<FormState>();

  String? typeSelector;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: SingleChildScrollView(
        // child: Form(
        //     key: _formKey,
        //     child: Column(
        //       children: [
        //         ListTile(
        //           title: TextFormField(
        //             decoration: const InputDecoration(label: Text("Name")),
        //             onChanged: (value) {
        //               queryBuilder("fname", value);
        //             },
        //           ),
        //         ),
        //         ListTile(
        //           title: Row(
        //             children: [
        //               Expanded(
        //                 child: TextFormField(
        //                   onChanged: (value) {
        //                     if (value != "") {
        //                       queryBuilder("atk", value);
        //                     } else {
        //                       removeQuery("atk");
        //                     }
        //                   },
        //                   keyboardType: TextInputType.number,
        //                   decoration: const InputDecoration(
        //                     label: Text("Atk"),
        //                   ),
        //                 ),
        //               ),
        //               const SizedBox(
        //                 width: 16,
        //               ),
        //               Expanded(
        //                 child: TextFormField(
        //                   onChanged: (value) {
        //                     queryBuilder("def", value);
        //                   },
        //                   keyboardType: TextInputType.number,
        //                   decoration: const InputDecoration(
        //                     label: Text("Def"),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         ListTile(
        //           title: TextFormField(
        //             onChanged: (value) {
        //               if (value != "") {
        //                 queryBuilder("level", value);
        //               } else {
        //                 removeQuery("level");
        //               }
        //             },
        //             keyboardType: TextInputType.number,
        //             decoration: const InputDecoration(
        //               label: Text("Level"),
        //             ),
        //           ),
        //         ),
        //         // Race(filter: raceSelector),
        //         //TODO Implement race filter
        //         ListTile(
        //           title: const Text("Card Type"),
        //           subtitle: DropdownButtonFormField<String>(
        //             isExpanded: true,
        //             elevation: 16,
        //             style: const TextStyle(color: Colors.deepPurple),
        //             onChanged: (String? newValue) {
        //               setState(() {
        //                 frameType = newValue;
        //                 raceSelector = null;
        //               });
        //
        //               switch(newValue){
        //                 case "Spell":
        //                   queryBuilder("type", "Spell Card");
        //                   break;
        //                 case "Trap" :
        //                   queryBuilder("type", "Trap Card");
        //                   break;
        //                 default:
        //                   break;
        //               }
        //             },
        //             items: CardFrameType.map<DropdownMenuItem<String>>(
        //                     (String value) {
        //                   return DropdownMenuItem<String>(
        //                     value: value,
        //                     child: Text(value),
        //                   );
        //                 }).toList(),
        //           ),
        //         ),
        //         //   subtitle: DropdownSelector(
        //         //     handleChange: handleChange,
        //         //     list: CardFrameType,
        //         //     selector: frameType,
        //         //   ),
        //         // ),
        //         // ListTile(
        //         //   title: TextFormField(
        //         //     onChanged: (value) {
        //         //       if (value != "") {
        //         //         queryBuilder("race", value);
        //         //       } else {
        //         //         removeQuery("race");
        //         //       }
        //         //     },
        //         //     //TODO: add race enum
        //         //     decoration: const InputDecoration(
        //         //       label: Text("Race"),
        //         //     ),
        //         //   ),
        //         // ),
        //         if (frameType == "Trap")
        //           ListTile(
        //             title: const Text("Trap Type"),
        //             subtitle: DropdownButtonFormField<String>(
        //               key: trapKey,
        //               hint: const Text("Type"),
        //               elevation: 16,
        //               style: const TextStyle(color: Colors.deepPurple),
        //               onChanged: (String? newValue) {
        //                 setState(() {
        //                   raceSelector = newValue!;
        //                 });
        //                 queryBuilder("type", "Trap Card");
        //                 queryBuilder("race", newValue!);
        //               },
        //               items: trapRaceList
        //                   .map<DropdownMenuItem<String>>((String value) {
        //                 return DropdownMenuItem<String>(
        //                   value: value,
        //                   child: Text(value),
        //                 );
        //               }).toList(),
        //             ),
        //           ),
        //         if (frameType == "Spell")
        //           ListTile(
        //             title: const Text("Spell Type"),
        //             subtitle: DropdownButtonFormField<String>(
        //               key: spellKey,
        //               hint: const Text("Type"),
        //               elevation: 16,
        //               style: const TextStyle(color: Colors.deepPurple),
        //               onChanged: (String? newValue) {
        //                 setState(() {
        //                   raceSelector = newValue!;
        //                 });
        //                 queryBuilder("type", "Spell Card");
        //                 queryBuilder("race", newValue!);
        //               },
        //               items: spellRaceList
        //                   .map<DropdownMenuItem<String>>((String value) {
        //                 return DropdownMenuItem<String>(
        //                   value: value,
        //                   child: Text(value),
        //                 );
        //               }).toList(),
        //             ),
        //           ),
        //         if (frameType != "Spell" && frameType != "Trap")
        //           ListTile(
        //             title: const Text("Monster Type"),
        //             subtitle: DropdownButtonFormField<String>(
        //               key: monsterKey,
        //               isExpanded: true,
        //               hint: const Text("Type"),
        //               elevation: 16,
        //               style: const TextStyle(color: Colors.deepPurple),
        //               onChanged: (String? newValue) {
        //                 setState(() {
        //                   typeSelector = newValue!;
        //                 });
        //                 queryBuilder("type", newValue!);
        //               },
        //               items: typeList
        //                   .map<DropdownMenuItem<String>>((String value) {
        //                 return DropdownMenuItem<String>(
        //                   value: value,
        //                   child: Text(value),
        //                 );
        //               }).toList(),
        //             ),
        //           ),
        //
        //         ListTile(
        //             title: const Text("Attribute"),
        //             subtitle: DropdownSelector(
        //               handleChange: handleChange,
        //               list: attributes,
        //               selector: attributeSelector,
        //               query: "attribute",
        //             )
        //           // DropdownButtonFormField<String>(
        //           //   hint: const Text("Attribute"),
        //           //   elevation: 16,
        //           //   style: const TextStyle(color: Colors.deepPurple),
        //           //   onChanged: (String? newValue) {
        //           //     setState(() {
        //           //       attributeSelector = newValue!;
        //           //     });
        //           //     queryBuilder("attribute", newValue!);
        //           //   },
        //           //   items:
        //           //       attributes.map<DropdownMenuItem<String>>((String value) {
        //           //     return DropdownMenuItem<String>(
        //           //       value: value,
        //           //       child: Text(value),
        //           //     );
        //           //   }).toList(),
        //           // ),
        //         ),
        //         ListTile(
        //           title: TextFormField(
        //             onChanged: (value) {
        //               queryBuilder("link", value);
        //             },
        //             keyboardType: TextInputType.number,
        //             decoration: const InputDecoration(
        //               label: Text("Link"),
        //             ),
        //           ),
        //         ),
        //         //TODO create new linkmarker widget for multiselection
        //         ListTile(
        //             title: const Text("Link marker"),
        //             subtitle: DropdownSelector(
        //               handleChange: handleChange,
        //               list: linkMarker,
        //               selector: linkMarkerSelector,
        //               query: "linkmarker",
        //             )
        //           // DropdownButtonFormField<String>(
        //           //   key: linkMarkerSelectorKey,
        //           //   hint: const Text("Link marker"),
        //           //   // value: linkMarkerSelector,
        //           //   elevation: 16,
        //           //   style: const TextStyle(color: Colors.deepPurple),
        //           //   onChanged: (String? newValue) {
        //           //     setState(() {
        //           //       linkMarkerSelector = newValue!;
        //           //     });
        //           //     queryBuilder("linkmarker", newValue!);
        //           //   },
        //           //   items:
        //           //       linkMarker.map<DropdownMenuItem<String>>((String value) {
        //           //     return DropdownMenuItem<String>(
        //           //       value: value,
        //           //       child: Text(value),
        //           //     );
        //           //   }).toList(),
        //           // ),
        //         ),
        //         ListTile(
        //           title: TextFormField(
        //             onChanged: (value) {
        //               queryBuilder("scale", value);
        //             },
        //             keyboardType: TextInputType.number,
        //             maxLength: 1,
        //             maxLengthEnforcement: MaxLengthEnforcement.enforced,
        //             decoration: const InputDecoration(
        //               label: Text("Scale"),
        //             ),
        //           ),
        //         ),
        //         ListTile(
        //           title: TextFormField(
        //             onChanged: (value) {
        //               queryBuilder("cardset", value);
        //             },
        //             decoration: const InputDecoration(
        //               label: Text("Cardset"),
        //             ),
        //           ),
        //         ),
        //         _buildArchetype(),
        //         ListTile(
        //           title: TextFormField(
        //             onChanged: (value) {
        //               queryBuilder("archetype", value);
        //             },
        //             decoration: const InputDecoration(
        //               label: Text("Archetype"),
        //             ),
        //           ),
        //         ),
        //         ListTile(
        //           title: const Text("Ban List"),
        //           subtitle: DropdownSelector(
        //             handleChange: handleChange,
        //             selector: banSelector,
        //             list: banList,
        //             query: "banlist",
        //           ),
        //           // DropdownButtonFormField<String>(
        //           //   hint: const Text("Banned from"),
        //           //   elevation: 16,
        //           //   style: const TextStyle(color: Colors.deepPurple),
        //           //   onChanged: (String? newValue) {
        //           //     setState(() {
        //           //       attributeSelector = newValue!;
        //           //     });
        //           //     queryBuilder("banlist", newValue!);
        //           //   },
        //           //   items: banList.map<DropdownMenuItem<String>>((String value) {
        //           //     return DropdownMenuItem<String>(
        //           //       value: value,
        //           //       child: Text(value),
        //           //     );
        //           //   }).toList(),
        //           // ),
        //         ),
        //         ListTile(
        //           title: const Text("Sort Order"),
        //           subtitle: DropdownSelector(
        //             handleChange: handleChange,
        //             selector: sortSelector,
        //             list: sortType,
        //             query: "sort",
        //           ),
        //           // DropdownButtonFormField<String>(
        //           //   hint: const Text("Sort order"),
        //           //   elevation: 16,
        //           //   style: const TextStyle(color: Colors.deepPurple),
        //           //   onChanged: (String? newValue) {
        //           //     setState(() {
        //           //       sortSelector = newValue!;
        //           //     });
        //           //     queryBuilder("sort", newValue!);
        //           //   },
        //           //   items: <String>[
        //           //     'Atk',
        //           //     'Def',
        //           //     'Name',
        //           //     'Type',
        //           //     'Level',
        //           //     'Id',
        //           //     'New'
        //           //   ].map<DropdownMenuItem<String>>((String value) {
        //           //     return DropdownMenuItem<String>(
        //           //       value: value,
        //           //       child: Text(value),
        //           //     );
        //           //   }).toList(),
        //           // ),
        //         ),
        //         ListTile(
        //           title: ElevatedButton(
        //             onPressed: () {
        //               // handleSearch();
        //               widget.search(query);
        //             },
        //             child: const Text("Search"),
        //           ),
        //         ),
        //       ],
        //     )),

        //
        // NEW FORMAT FOLLOWING MASTER DUEL SEARCH TAB
        //
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                //TODO make on toggle change global store
                // const SizedBox(
                //   height: 200,
                //   child: FilterTypes(),
                // ),
                // const SizedBox(
                //   height: 200,
                //   child: FilterAttributes(),
                // ),
                ListTile(
                  title: TextFormField(
                    decoration: const InputDecoration(label: Text("Name")),
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
                        Provider.of<SearchTags>(context, listen: false)
                            .setLevel(value);
                      } else {
                        removeQuery("level");
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text("Level"),
                      suffix:
                          Text("${Provider.of<SearchTags>(context).cardLevel}"),
                    ),
                  ),
                ),
                // Race(filter: raceSelector),
                //TODO Implement race filter
                ListTile(
                  title: const Text("Card Type"),
                  subtitle: DropdownButtonFormField<String>(
                    isExpanded: true,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? newValue) {
                      setState(() {
                        frameType = newValue;
                        raceSelector = null;
                      });

                      switch (newValue) {
                        case "Spell":
                          queryBuilder("type", "Spell Card");
                          break;
                        case "Trap":
                          queryBuilder("type", "Trap Card");
                          break;
                        default:
                          break;
                      }
                    },
                    items: CardFrameType.map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                //   subtitle: DropdownSelector(
                //     handleChange: handleChange,
                //     list: CardFrameType,
                //     selector: frameType,
                //   ),
                // ),
                // ListTile(
                //   title: TextFormField(
                //     onChanged: (value) {
                //       if (value != "") {
                //         queryBuilder("race", value);
                //       } else {
                //         removeQuery("race");
                //       }
                //     },
                //     //TODO: add race enum
                //     decoration: const InputDecoration(
                //       label: Text("Race"),
                //     ),
                //   ),
                // ),
                if (frameType == "Trap")
                  ListTile(
                    title: const Text("Trap Type"),
                    subtitle: DropdownButtonFormField<String>(
                      key: trapKey,
                      hint: const Text("Type"),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      onChanged: (String? newValue) {
                        setState(() {
                          raceSelector = newValue!;
                        });
                        queryBuilder("type", "Trap Card");
                        queryBuilder("race", newValue!);
                      },
                      items: trapRaceList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                if (frameType == "Spell")
                  ListTile(
                    title: const Text("Spell Type"),
                    subtitle: DropdownButtonFormField<String>(
                      key: spellKey,
                      hint: const Text("Type"),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      onChanged: (String? newValue) {
                        setState(() {
                          raceSelector = newValue!;
                        });
                        queryBuilder("type", "Spell Card");
                        queryBuilder("race", newValue!);
                      },
                      items: spellRaceList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                if (frameType != "Spell" && frameType != "Trap")
                  ListTile(
                    title: const Text("Monster Type"),
                    subtitle: DropdownButtonFormField<String>(
                      key: monsterKey,
                      isExpanded: true,
                      hint: const Text("Type"),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      onChanged: (String? newValue) {
                        setState(() {
                          typeSelector = newValue!;
                        });
                        queryBuilder("type", newValue!);
                      },
                      items: typeList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                ListTile(
                    title: const Text("Attribute"),
                    subtitle: DropdownSelector(
                      handleChange: handleChange,
                      list: attributes,
                      selector: attributeSelector,
                      query: "attribute",
                    )
                    // DropdownButtonFormField<String>(
                    //   hint: const Text("Attribute"),
                    //   elevation: 16,
                    //   style: const TextStyle(color: Colors.deepPurple),
                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       attributeSelector = newValue!;
                    //     });
                    //     queryBuilder("attribute", newValue!);
                    //   },
                    //   items:
                    //       attributes.map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    // ),
                    ),
                ListTile(
                  title: TextFormField(
                    onChanged: (value) {
                      queryBuilder("link", value);
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text("Link"),
                    ),
                  ),
                ),
                //TODO create new linkmarker widget for multiselection
                ListTile(
                    title: const Text("Link marker"),
                    subtitle: DropdownSelector(
                      handleChange: handleChange,
                      list: linkMarker,
                      selector: linkMarkerSelector,
                      query: "linkmarker",
                    )
                    // DropdownButtonFormField<String>(
                    //   key: linkMarkerSelectorKey,
                    //   hint: const Text("Link marker"),
                    //   // value: linkMarkerSelector,
                    //   elevation: 16,
                    //   style: const TextStyle(color: Colors.deepPurple),
                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       linkMarkerSelector = newValue!;
                    //     });
                    //     queryBuilder("linkmarker", newValue!);
                    //   },
                    //   items:
                    //       linkMarker.map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    // ),
                    ),
                ListTile(
                  title: TextFormField(
                    onChanged: (value) {
                      queryBuilder("scale", value);
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                  title: const Text("Ban List"),
                  subtitle: DropdownSelector(
                    handleChange: handleChange,
                    selector: banSelector,
                    list: banList,
                    query: "banlist",
                  ),
                  // DropdownButtonFormField<String>(
                  //   hint: const Text("Banned from"),
                  //   elevation: 16,
                  //   style: const TextStyle(color: Colors.deepPurple),
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       attributeSelector = newValue!;
                  //     });
                  //     queryBuilder("banlist", newValue!);
                  //   },
                  //   items: banList.map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  // ),
                ),
                ListTile(
                  title: const Text("Sort Order"),
                  subtitle: DropdownSelector(
                    handleChange: handleChange,
                    selector: sortSelector,
                    list: sortType,
                    query: "sort",
                  ),
                  // DropdownButtonFormField<String>(
                  //   hint: const Text("Sort order"),
                  //   elevation: 16,
                  //   style: const TextStyle(color: Colors.deepPurple),
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       sortSelector = newValue!;
                  //     });
                  //     queryBuilder("sort", newValue!);
                  //   },
                  //   items: <String>[
                  //     'Atk',
                  //     'Def',
                  //     'Name',
                  //     'Type',
                  //     'Level',
                  //     'Id',
                  //     'New'
                  //   ].map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  // ),
                ),
                ListTile(
                  title: ElevatedButton(
                    onPressed: () {
                      // handleSearch();
                      widget.search(query);
                    },
                    child: const Text("Search"),
                  ),
                ),
              ],
            )),
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
  }

  void removeQuery(String s) {
    query?.remove(s);
  }

  void handleChange(newValue, selector, String query) {
    debugPrint("Value changed");
    setState(() {
      selector = newValue!;
    });
    queryBuilder(query, newValue!);
  }
}
