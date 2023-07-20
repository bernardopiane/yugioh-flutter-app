import 'package:flutter/material.dart';
import 'package:yugi_deck/models/filter_options.dart';

class FilterCards extends StatefulWidget {
  final Function(FilterOptions) selectedFilters;
  final FilterOptions preselectedFilters;

  const FilterCards({Key? key, required this.selectedFilters, required this.preselectedFilters}) : super(key: key);

  @override
  FilterCardsState createState() => FilterCardsState();
}

class FilterCardsState extends State<FilterCards> {
  //TODO: move filterOptions up to keep state on search Screen
  FilterOptions filterOptions = FilterOptions();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterOptions = widget.preselectedFilters;
  }

  final List<String> cardTypes = [
    'MONSTER',
    "EFFECT",
    "FUSION",
    "RITUAL",
    "SYNCHRO",
    "XYZ",
    "PENDULUM",
    "LINK",
    'SPELL',
    'TRAP'
  ];
  final List<String> attributes = [
    'FIRE',
    'WATER',
    'WIND',
    'EARTH',
    "LIGHT",
    "DARK",
    "DIVINE"
  ];
  final List<String> spellTrapTypes = [
    'NORMAL SPELL',
    "FIELD SPELL",
    "EQUIP SPELL",
    'CONTINUOUS SPELL',
    'QUICK-PLAY SPELL',
    'RITUAL SPELL',
    "NORMAL TRAP",
    "CONTINUOUS TRAP",
    "COUNTER TRAP"
  ];
  final List<String> monsterTypes = [
    "SPELLCASTER",
    "DRAGON",
    "ZOMBIE",
    "WARRIOR",
    "BEAST-WARRIOR",
    "BEAST",
    "WINGED BEAST",
    "MACHINE",
    "FIEND",
    "FAIRY",
    "INSECT",
    "DINOSAUR",
    "REPTILE",
    "FISH",
    "SEA SERPENT",
    "AQUA",
    "PYRO",
    "THUNDER",
    "ROCK",
    "PLANT",
    "PSYCHIC",
    "WYRM",
    "CYBERSE",
    "DIVINE-BEAST"
  ];
  final List<int> levels = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];

  void toggleCardType(String type) {
    setState(() {
      if (filterOptions.cardTypes.contains(type)) {
        filterOptions.cardTypes.remove(type);
      } else {
        filterOptions.cardTypes.add(type);
      }
    });
  }

  void toggleAttribute(String attribute) {
    setState(() {
      if (filterOptions.attributes.contains(attribute)) {
        filterOptions.attributes.remove(attribute);
      } else {
        filterOptions.attributes.add(attribute);
      }
    });
  }

  void toggleSpellTrapType(String type) {
    setState(() {
      if (filterOptions.spellTrapTypes.contains(type)) {
        filterOptions.spellTrapTypes.remove(type);
      } else {
        filterOptions.spellTrapTypes.add(type);
      }
    });
  }

  void toggleMonsterType(String type) {
    setState(() {
      if (filterOptions.monsterTypes.contains(type)) {
        filterOptions.monsterTypes.remove(type);
      } else {
        filterOptions.monsterTypes.add(type);
      }
    });
  }

  void toggleLevel(int level) {
    setState(() {
      if (filterOptions.levels.contains(level)) {
        filterOptions.levels.remove(level);
      } else {
        filterOptions.levels.add(level);
      }
    });
  }

  Widget buildToggleButton(String text, bool selected, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.blue : Colors.grey,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Options'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Card Types',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: cardTypes.map((type) {
                  final selected = filterOptions.cardTypes.contains(type);
                  return buildToggleButton(
                      type, selected, () => toggleCardType(type));
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Attributes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: attributes.map((attribute) {
                  final selected = filterOptions.attributes.contains(attribute);
                  return buildToggleButton(
                      attribute, selected, () => toggleAttribute(attribute));
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Spell/Trap Types',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: spellTrapTypes.map((type) {
                  final selected = filterOptions.spellTrapTypes.contains(type);
                  return buildToggleButton(
                      type, selected, () => toggleSpellTrapType(type));
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Monster Types',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: monsterTypes.map((type) {
                  final selected = filterOptions.monsterTypes.contains(type);
                  return buildToggleButton(
                      type, selected, () => toggleMonsterType(type));
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Levels',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: levels.map((level) {
                  final selected = filterOptions.levels.contains(level);
                  return buildToggleButton(
                      level.toString(), selected, () => toggleLevel(level));
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Apply the filter options
                  // Call a method or navigate back with the selected filter options
                  debugPrint(filterOptions.toString());
                  widget.selectedFilters(filterOptions); // Invoke the callback with the data
                  Navigator.pop(context); // Close the child page
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
