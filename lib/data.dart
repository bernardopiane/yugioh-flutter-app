import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:http/http.dart' as http;

import 'globals.dart';

class DataProvider extends ChangeNotifier {
  List<CardV2> cards = [];

  DataProvider(this.cards);

  Future<void> loadData() async {
    //  Check if already exists
    if (cards.isEmpty) {
      await fetchDataAndStoreInHive();
    }

    // FlutterNativeSplash.remove();
    //  Compare version with API
    //  Update if needed
  }

  setResult(List<CardV2> res) {
    cards = res;
    notifyListeners();
  }

  Future<void> fetchDataAndStoreInHive() async {
    var box = await Hive.openBox("database");

    try {
      final response = await http
          .get(Uri.parse('https://db.ygoprodeck.com/api/v7/checkDBVer.php'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final databaseVersion = json[0]['database_version'];
        final lastUpdate = json[0]['last_update'];

        debugPrint("Box Database Version : ${box.get("database_version")}");
        debugPrint("API Database Version : $databaseVersion");
        debugPrint("Box Update Date : ${box.get("last_update")}");
        debugPrint("API Update Data : $lastUpdate");

        if (box.get("database_version") != databaseVersion ||
            box.get("last_update") != lastUpdate) {
          try {
            final newData = await fetchNewData();
            box.put("database_version", databaseVersion);
            box.put("last_update", lastUpdate);
            setResult(newData);
            var jsonData = jsonEncode(newData);
            box.put("json_data", jsonData);
          } catch (e) {
            var snackBar = const SnackBar(
              content: Text(
                  "Failed to fetch latest cards from API. Data may be outdated"),
            );
            snackbarKey.currentState?.showSnackBar(snackBar);
            debugPrint("Error fetching new data: $e");

            setResult(box.get("json_data"));

            // Handle the error
          }
        } else {
          var jsonData = box.get("json_data");
          List<dynamic> list = jsonData != null ? jsonDecode(jsonData) : [];

          List<CardV2> cardList =
              list.map((card) => CardV2.fromJson(card)).toList();

          setResult(cardList);
        }
      } else {
        debugPrint("Error fetching API database version");
        var snackBar = const SnackBar(
          content: Text("Failed to connect to the API. Please restart the app"),
        );
        snackbarKey.currentState?.showSnackBar(snackBar);

        // TODO: Handle API call failure
      }
    } on TimeoutException catch (_) {
      debugPrint("Try Catch 1.");
      var jsonData = box.get("json_data");
      List<dynamic> list = jsonData != null ? jsonDecode(jsonData) : [];

      List<CardV2> cardList =
          list.map((card) => CardV2.fromJson(card)).toList();

      setResult(cardList);
    } on SocketException catch (_) {
      debugPrint("Try Catch 2");
      var jsonData = box.get("json_data");
      List<dynamic> list = jsonData != null ? jsonDecode(jsonData) : [];

      List<CardV2> cardList =
          list.map((card) => CardV2.fromJson(card)).toList();

      setResult(cardList);
    } catch (e) {
      debugPrint("An error occurred: $e");
    }
  }

  Future<List<CardV2>> fetchNewData() async {
    debugPrint("Fetch new data");
    try {
      final response = await http
          .post(Uri.parse("https://db.ygoprodeck.com/api/v7/cardinfo.php"))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json["error"] != null) {
          return [];
        }

        final lista = json["data"] as List;

        final cardV2List =
            lista.map((element) => CardV2.fromJson(element)).toList();

        return cardV2List;
      } else {
        debugPrint(
            "Error fetching new data. Status Code: ${response.statusCode}");
        return [];
      }
    } on TimeoutException catch (_) {
      debugPrint("Request timed out. Please check your internet connection.");
      return [];
    } on SocketException catch (_) {
      debugPrint("No internet connection");
      return [];
    } catch (e) {
      debugPrint("An error occurred: $e");
      return [];
    }
  }

  Future<void> forceUpdate() async {
    var box = await Hive.openBox("database");

    try {
      final newData = await fetchNewData();
      setResult(newData);
      var jsonData = jsonEncode(newData);
      box.put("json_data", jsonData);
    } catch (e) {
      var snackBar = const SnackBar(
        content: Text("Failed to fetch latest cards from API"),
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      debugPrint("Error fetching new data: $e");
      // Handle the error
    }
  }
}
