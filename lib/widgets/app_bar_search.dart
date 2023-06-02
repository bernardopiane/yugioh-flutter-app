import 'package:flutter/material.dart';

class AppBarSearch extends StatelessWidget {
  const AppBarSearch(
      {Key? key, required this.searchController, required this.search})
      : super(key: key);
  final TextEditingController searchController;
  final Function search;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: TextField(
          autofocus: false,
          controller: searchController,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  search("");
                },
              ),
              hintText: 'Search...',
              border: InputBorder.none),
          onEditingComplete: () {
            search(searchController.value.text);
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }
}
