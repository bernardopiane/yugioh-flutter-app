import 'package:flutter/material.dart';
import 'package:yugi_deck/models/card_attributes.dart';

class AdvSearch extends StatefulWidget {
  const AdvSearch({Key? key}) : super(key: key);

  @override
  State<AdvSearch> createState() => _AdvSearchState();
}

class _AdvSearchState extends State<AdvSearch> {
  String? raceSelector;

  String? sortSelector;

  String? attributeSelector;

  String? query;

  //TODO: Seguir formato de busca do MD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advanced Search"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: TextField(
                decoration: const InputDecoration(label: Text("Name")),
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onTap: () {},
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
                    child: TextField(
                      onTap: () {},
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
              title: TextField(
                onTap: () {},
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Level"),
                ),
              ),
            ),
            ListTile(
              title: TextField(
                onTap: () {},
                decoration: const InputDecoration(
                  label: Text("Race"),
                ),
              ),
            ),
            ListTile(
              title: const Text("Attribute"),
              subtitle: DropdownButtonFormField<String>(
                value: attributeSelector,
                hint: const Text("Attribute"),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                onChanged: (String? newValue) {
                  setState(() {
                    attributeSelector = newValue!;
                  });
                },
                items: attributes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: TextField(
                onTap: () {},
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Link"),
                ),
              ),
            ),
            ListTile(
              title: TextField(
                onTap: () {},
                decoration: const InputDecoration(
                  label: Text("Link marker"),
                ),
              ),
            ),
            ListTile(
              title: TextField(
                onTap: () {},
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Scale"),
                ),
              ),
            ),
            ListTile(
              title: TextField(
                onTap: () {},
                decoration: const InputDecoration(
                  label: Text("Cardset"),
                ),
              ),
            ),
            ListTile(
              title: TextField(
                onTap: () {},
                decoration: const InputDecoration(
                  label: Text("Archetype"),
                ),
              ),
            ),
            ListTile(
              title: TextField(
                onTap: () {},
                decoration: const InputDecoration(
                  label: Text("Banlist"),
                ),
              ),
            ),
            ListTile(
              title: const Text("Sort Order"),
              subtitle: DropdownButtonFormField<String>(
                hint: const Text("Sort order"),
                value: sortSelector,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                onChanged: (String? newValue) {
                  setState(() {
                    sortSelector = newValue!;
                  });
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
                onPressed: () {},
                child: const Text("Search"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
