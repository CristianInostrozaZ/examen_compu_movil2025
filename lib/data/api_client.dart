import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = 'http://143.198.118.203:8100';
  static const String _user = 'test';
  static const String _pass = 'test2023';

  static const Duration _timeout = Duration(seconds: 20);

  static Map<String, String> get _headers => {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Uri _uri(String path) {
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$_baseUrl$p');
  }

  static Future<http.Response> get(String path) {
    return http
        .get(_uri(path), headers: _headers)
        .timeout(_timeout);
  }

  static Future<http.Response> post(String path, Map<String, dynamic> body) {
    return http
        .post(_uri(path), headers: _headers, body: json.encode(body))
        .timeout(_timeout);
  }
}
