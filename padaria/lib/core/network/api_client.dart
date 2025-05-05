import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "https://parseapi.back4app.com/";
  static const Map<String, String> headers = {
    "X-Parse-Application-Id": "",
    "X-Parse-REST-API-Key": "",
    "Content-Type": "application/json",
  };

  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['result'];
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }
}
