import 'package:flutter/material.dart';

class FilterTypes extends StatefulWidget {
  const FilterTypes({Key? key}) : super(key: key);

  @override
  FilterTypesState createState() => FilterTypesState();
}

class FilterTypesState extends State<FilterTypes> {
  final List<String> cardTypes = [
    'Normal',
    'Effect',
    'Fusion',
    'Ritual',
    'Synchro',
    'Xyz',
    'Pendulum',
    'Link',
    'Spell',
    'Trap',
  ];

  Set<String> selectedCardTypes = {};

  void toggleCardType(String cardType) {
    setState(() {
      if (selectedCardTypes.contains(cardType)) {
        selectedCardTypes.remove(cardType);
      } else {
        selectedCardTypes.add(cardType);
      }
    });
  }

  bool isCardTypeSelected(String cardType) {
    return selectedCardTypes.contains(cardType);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: cardTypes.map((cardType) {
        return FilterChip(
          showCheckmark: false,
          selectedColor: Colors.amber,
          //TODO follow games colors pattern
          label: Text(cardType),
          selected: isCardTypeSelected(cardType),
          onSelected: (isSelected) {
            toggleCardType(cardType);
          },
        );
      }).toList(),
    );
  }
}
