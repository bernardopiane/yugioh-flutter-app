import 'package:flutter/material.dart';
import 'package:yugi_deck/models/filter_options.dart';
import 'package:yugi_deck/widgets/filter_cards.dart';

class FilterPage extends StatefulWidget {
  final Function(FilterOptions) applyFilter;
  final FilterOptions activeFilters;

  const FilterPage({Key? key, required this.applyFilter, required this.activeFilters}) : super(key: key);

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
    return FilterCards(selectedFilters: selectedFilters, preselectedFilters: widget.activeFilters);
  }
}
