import 'dart:convert';
import 'package:http/http.dart' as http;

const String ip = "http://192.168.18.7:3000/hotels";

Future<dynamic> postReq(String endpoint, dynamic data) async {
  final url = Uri.parse('$ip/$endpoint');

  try {
    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    return response;
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<dynamic> getReq(String endpoint) async {
  final url = Uri.parse('$ip/$endpoint');

  try {
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    return response;
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<dynamic> deleteReq(String endpoint) async {
  final url = Uri.parse('$ip/$endpoint');

  try {
    http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    throw Exception('Error: $e');
  }
}
