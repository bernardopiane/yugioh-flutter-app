import 'package:flutter/material.dart';

class AppBarSearch extends StatelessWidget {
  const AppBarSearch({
    Key? key,
    required this.searchController,
    required this.search,
    required this.clear,
  }) : super(key: key);

  final TextEditingController searchController;
  final Function(String) search;
  final VoidCallback clear;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2, // Add elevation for Material design
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SizedBox(
          height: 48, // Adjusted height for better visibility
          child: Center(
        child: TextField(
              autofocus: false,
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    clear();
                  },
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              onEditingComplete: () {
            search(searchController.value.text);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ),
      ),
          );
  }
}
