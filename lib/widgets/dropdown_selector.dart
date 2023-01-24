import 'package:flutter/material.dart';

class DropdownSelector extends StatelessWidget {
  final Function handleChange;
  final String? selector;
  final String query;
  final List<String> list;
  const DropdownSelector(
      {Key? key,
      required this.handleChange,
      required this.list,
      this.selector,
      required this.query})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        handleChange(newValue, selector, query);
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
