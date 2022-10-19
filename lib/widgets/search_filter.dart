import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yugi_deck/models/card_attributes.dart';
import 'package:yugi_deck/models/card_banlist.dart';
import 'package:yugi_deck/models/card_link_marker.dart';
import 'package:yugi_deck/models/card_race.dart';
import 'package:yugi_deck/models/card_type.dart';

import '../card_info_entity.dart';
import '../utils.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({Key? key, required this.search}) : super(key: key);

  final Function(Map<String, String>? query) search;
  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  String? raceSelector;

  String? sortSelector;

  String? attributeSelector;

  String? linkMarkerSelector;

  Map<String, String>? query;

  Future<List<CardInfoEntity>>? data;

  final GlobalKey dataKey = GlobalKey();

  final GlobalKey<FormFieldState> linkMarkerSelectorKey =
      GlobalKey<FormFieldState>();

  final _formKey = GlobalKey<FormState>();

  String? typeSelector;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                  onChanged: (value) {
                    if (value != "") {
                      queryBuilder("race", value);
                    } else {
                      removeQuery("race");
                    }
                  },
                  //TODO: add race enum
                  decoration: const InputDecoration(
                    label: Text("Race"),
                  ),
                ),
              ),
              ListTile(
                title: const Text("Type"),
                subtitle: DropdownButtonFormField<String>(
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
                  items: typeList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              if (typeSelector == "Trap Card")
                ListTile(
                  title: const Text("Trap Race"),
                  subtitle: DropdownButtonFormField<String>(
                    hint: const Text("Race"),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? newValue) {
                      setState(() {
                        raceSelector = newValue!;
                      });
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
              if (typeSelector == "Spell Card")
                ListTile(
                  title: const Text("Spell Race"),
                  subtitle: DropdownButtonFormField<String>(
                    hint: const Text("Race"),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? newValue) {
                      setState(() {
                        raceSelector = newValue!;
                      });
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
                  items:
                      attributes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
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
              ListTile(
                // title: const Text("Link marker"),
                subtitle: DropdownButtonFormField<String>(
                  key: linkMarkerSelectorKey,
                  hint: const Text("Link marker"),
                  // value: linkMarkerSelector,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    setState(() {
                      linkMarkerSelector = newValue!;
                    });
                    queryBuilder("linkmarker", newValue!);
                  },
                  items:
                      linkMarker.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
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
                subtitle: DropdownButtonFormField<String>(
                  hint: const Text("Banned from"),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    setState(() {
                      attributeSelector = newValue!;
                    });
                    queryBuilder("banlist", newValue!);
                  },
                  items: banList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
                    // handleSearch();
                    widget.search(query);
                  },
                  child: const Text("Search"),
                ),
              ),
            ],
          )),
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
}
