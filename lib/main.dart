import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/data.dart';
import 'package:yugi_deck/globals.dart';
import 'package:yugi_deck/models/deck_list.dart';
import 'package:yugi_deck/models/query_results.dart';
import 'package:yugi_deck/models/search_tags.dart';
import 'package:yugi_deck/pages/my_home_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Hive.initFlutter();
  // Lock vertical only

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DeckList>(
              create: (_) => DeckList([]),
            ),
            ChangeNotifierProvider<QueryResults>(
              create: (_) => QueryResults([]),
            ),
            ChangeNotifierProvider<DataProvider>(
              create: (_) => DataProvider([]),
            ),
            ChangeNotifierProvider<SearchTags>(
              create: (_) => SearchTags(),
            )
          ],
          child: const MyApp(),
        ),
      ));

  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider<DeckList>(
  //         create: (_) => DeckList([]),
  //       ),
  //       ChangeNotifierProvider<QueryResults>(
  //         create: (_) => QueryResults([]),
  //       ),
  //     ],
  //     child: const MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<DeckList>(context, listen: false).loadFromFile(context);

    Provider.of<DataProvider>(context, listen: false).loadData();

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
