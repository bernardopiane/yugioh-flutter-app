import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yugi_deck/data.dart';
import 'package:yugi_deck/globals.dart';
import 'package:yugi_deck/models/deck_list.dart';
import 'package:yugi_deck/models/query_results.dart';
import 'package:yugi_deck/pages/login_or_user_page.dart';
import 'package:yugi_deck/pages/main_page.dart';
import 'package:yugi_deck/pages/my_home_page.dart';
import 'package:yugi_deck/pages/splash_page.dart';
import 'package:yugi_deck/pages/user_page.dart';
import 'package:yugi_deck/widgets/theme_notifier.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//

// Light theme
final lightTheme = ThemeData(
  brightness: Brightness.light,
);

// Dark theme
final darkTheme = ThemeData(
  brightness: Brightness.dark,
);

Future<void> main() async {
  await Hive.initFlutter();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
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
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(prefs),
        ),
      ],
      child: MyApp(prefs: prefs),
    ),
  );
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData(context);
  }

  Future<void> loadData(BuildContext context) async {
    final deckListProvider = Provider.of<DeckList>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    try {
      await deckListProvider.loadFromFile(context);
      await dataProvider.loadData();
    } catch (error) {
      // Handle loading errors
      debugPrint('Error loading data: $error');
      // Show error message to the user
      const snackBar = SnackBar(content: Text('Failed to load data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return MaterialApp(
          title: 'MD Deck',
          scaffoldMessengerKey: snackbarKey,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.currentTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            // Define the named routes
            '/login': (context) => const LoginOrUserPage(),
          },
          home: AnimatedSwitcher(
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            duration: const Duration(milliseconds: 500),
            child: isLoading ? const SplashPage() : const MyHomePage(),
          ),
        );
      },
    );
  }
}
