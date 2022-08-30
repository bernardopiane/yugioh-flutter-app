import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/globals.dart';
import 'package:yugi_deck/models/deck_list.dart';
import 'package:yugi_deck/pages/my_home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      //TODO: implement saving to storage
      create: (_) => DeckList([]),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MD Deck',
        scaffoldMessengerKey: snackbarKey,
        theme: ThemeData(
          brightness: Brightness.light,
          /* light theme settings */
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        themeMode: ThemeMode.system,
        /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
        debugShowCheckedModeBanner: false,
        home: const MyHomePage());
  }
}
