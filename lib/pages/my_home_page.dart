import 'package:flutter/material.dart';
import 'package:yugi_deck/pages/adv_search.dart';
import 'package:yugi_deck/pages/deck_list_page.dart';
import 'package:yugi_deck/pages/main_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  PageController _pageController = PageController();
  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 250), curve: Curves.ease);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // TODO: Changing app keep state
    super.initState();

    _pages = [
      const MainPage(),
      const DeckListPage(),
    ];

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MD Deck'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DeckListPage(),
              ),
            );
          }, icon: const Icon(Icons.save_alt))
        ],
      ),
      body: Center(
        // child: _widgetOptions.elementAt(_selectedIndex),
        child: PageView(
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          controller: _pageController,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save_rounded),
            label: 'Saved Decks',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
