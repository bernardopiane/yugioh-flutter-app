import 'package:flutter/material.dart';
import 'package:yugi_deck/models/filter_options.dart';

class FilterCards extends StatefulWidget {
  final Function(FilterOptions) selectedFilters;

  const FilterCards({Key? key, required this.selectedFilters}) : super(key: key);

  @override
  FilterCardsState createState() => FilterCardsState();
}

class FilterCardsState extends State<FilterCards> {
  //TODO: move filterOptions up to keep state on search Screen
  FilterOptions filterOptions = FilterOptions();

  final List<String> cardTypes = [
    'Monster',
    "Effect",
    "Fusion",
    "Ritual",
    "Synchro",
    "Xyz",
    "Pendulum",
    "Link",
    'Spell',
    'Trap'
  ];
  final List<String> attributes = [
    'Fire',
    'Water',
    'Wind',
    'Earth',
    "Light",
    "Dark",
    "Divine"
  ];
  final List<String> spellTrapTypes = [
    'Normal Spell',
    "Field Spell",
    "Equip Spell",
    'Continuous Spell',
    'Quick-Play Spell',
    'Ritual Spell',
    "Normal Trap",
    "Continuous Trap",
    "Counter Trap"
  ];
  final List<String> monsterTypes = [
    "Spellcaster",
    "Dragon",
    "Zombie",
    "Warrior",
    "Beast-Warrior",
    "Beast",
    "Winged Beast",
    "Machine",
    "Fiend",
    "Fairy",
    "Insect",
    "Dinosaur",
    "Reptile",
    "Fish",
    "Sea Serpent",
    "Aqua",
    "Pyro",
    "Thunder",
    "Rock",
    "Plant",
    "Psychic",
    "Wyrm",
    "Cyberse",
    "Divine-Beast"
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blue : Colors.grey,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
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
