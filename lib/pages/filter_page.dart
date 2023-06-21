import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/models/filter_options.dart';
import 'package:yugi_deck/widgets/filter_cards.dart';

import '../data.dart';

class FilterPage extends StatefulWidget {
  final Function(FilterOptions) applyFilter;

  const FilterPage({Key? key, required this.applyFilter}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  FilterOptions filterOptions = FilterOptions();

  void selectedFilters(FilterOptions data) {
    setState(() {
      filterOptions = data;
    });
    widget.applyFilter(data);
  }

  @override
  Widget build(BuildContext context) {
    return FilterCards(selectedFilters: selectedFilters);
  }
}
