import 'dart:convert';

import 'package:http/http.dart' as http;

// ignore: camel_case_types
class API_Manager {
  Future<bool> getNews(log, pass) async {
    var client = http.Client();
    var newsModel;

    try {
      var response = await client
          .get(Uri.parse('http://192.168.1.2:443/sz/hs/RestAPI/v1/'));
      if (response.statusCode == 200) {
        // var jsonString = response.body;
        // var jsonMap = json.decode(jsonString);

        // newsModel = NewsModel.fromJson(jsonMap);
        return true;
      }
    } catch (Exception) {
      return false;
    }

    return true;
  }
}
