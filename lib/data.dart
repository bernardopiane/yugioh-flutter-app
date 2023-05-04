import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:http/http.dart' as http;

class DataProvider extends ChangeNotifier {
  List<CardV2> cards = [];

  DataProvider(this.cards);

  loadData() async {
    //  Check if already exists
    if (cards.isEmpty) {
      var box = await Hive.openBox("database");
      debugPrint("API Version stored: ${box.get("api_version")}");
      fetchDataAndStoreInHive();
    }
    //  Compare version with API
    //  Update if needed
  }

  setResult(List<CardV2> res) {
    cards = res;
    notifyListeners();
  }

  Future<void> fetchDataAndStoreInHive() async {
    final response = await http
        .get(Uri.parse('https://db.ygoprodeck.com/api/v7/checkDBVer.php'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final databaseVersion = json[0]['database_version'];
      final lastUpdate = json[0]['last_update'];

      var box = await Hive.openBox("database");
      debugPrint("Box Database Version : ${box.get("database_version")}");
      debugPrint("API Database Version : $databaseVersion");
      debugPrint("Box Update Date : ${box.get("last_update")}");
      debugPrint("API Update Data : $lastUpdate");

      if (box.get("database_version") != databaseVersion ||
          box.get("last_update") != lastUpdate) {
        fetchNewData().then((newData) {
          box.put("database_version", databaseVersion);
          box.put("last_update", lastUpdate);
          setResult(newData);
        //  TODO: add data to Hive box
          var jsonData = jsonEncode(newData);
          box.put("json_data", jsonData);
        });
      } else {
        List list = [];

        var jsonData = box.get("json_data");

        list = jsonDecode(jsonData);


        //TODO: handle data from hive to object

        setResult(list.cast<CardV2>());
      }
    } else {
      debugPrint("Error fetching API database version");
      // Handle API call failure
    }
  }

  Future<List<CardV2>> fetchNewData() async {
    debugPrint("Fetch new data");
    try {
      var response = await http
          .post(Uri.parse("https://db.ygoprodeck.com/api/v7/cardinfo.php"))
          .timeout(const Duration(seconds: 30));

      List<CardV2> cardV2List = [];

      var json = jsonDecode(response.body);

      if (json["error"] != null) {
        return cardV2List;
      }

      var lista = json["data"] as List;

      for (var element in lista) {
        CardV2 card = CardV2.fromJson(element);
        cardV2List.add(card);
      }

      return cardV2List;
    } on TimeoutException catch (_) {
      debugPrint("Request timed out. Please check your internet connection.");
      return [];
    } on SocketException catch (_) {
      debugPrint("No internet connection");
      return [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}