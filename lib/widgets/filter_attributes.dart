import 'package:flutter/material.dart';

class FilterAttributes extends StatefulWidget {
  const FilterAttributes({Key? key}) : super(key: key);

  @override
  FilterAttributesState createState() => FilterAttributesState();
}

class FilterAttributesState extends State<FilterAttributes> {
  final List<String> cardAttributes = [
    'LIGHT',
    'DARK',
    'WATER',
    'FIRE',
    'EARTH',
    'WIND',
    'DIVINE',
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
      children: cardAttributes.map((cardType) {
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
