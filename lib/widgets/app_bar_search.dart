import 'package:flutter/material.dart';

class AppBarSearch extends StatefulWidget {
  const AppBarSearch({
    Key? key,
    required this.searchController,
    required this.search,
    required this.clear,
    required this.pageTitle,
  }) : super(key: key);

  final TextEditingController searchController;
  final Function(String) search;
  final VoidCallback clear;
  final String pageTitle;

  @override
  State<AppBarSearch> createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch> {
  bool _searchExpanded = false;

  @override
  Widget build(BuildContext context) {
    return _searchExpanded
        ? Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                  controller: widget.searchController,
                  onEditingComplete: () {
                    widget.search(widget.searchController.value.text);
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _searchExpanded = !_searchExpanded;
                    });
                  }),
            ],
          )
        : Row(
            children: [
              Expanded(child: Text(widget.pageTitle)),
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchExpanded = !_searchExpanded;
                    });
                  }),
            ],
          );
  }
}
