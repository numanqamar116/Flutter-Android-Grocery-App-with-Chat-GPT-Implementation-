import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ControlsService {
  static Future<void> fetchDataAndStore() async {
    const url = 'https://footytv.live/apps/nfl.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('data', json.encode(jsonData));
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  static Future<Map<String, dynamic>> getDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('data');

    if (jsonData != null) {
      return json.decode(jsonData);
    } else {
      throw Exception('No data found in shared preferences');
    }
  }
}
