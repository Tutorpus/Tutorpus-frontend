import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  static String? _token;

  // 토큰 설정 함수
  static void setToken(String token) {
    _token = token;
  }

  // SharedPreferences에서 토큰 로드
  static Future<void> loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  // GET 요청
  Future<http.Response> get(String url) async {
    if (_token == null) {
      await loadTokenFromStorage();
    }
    return http.get(
      Uri.parse(url),
      headers: {
        'Authorization': _token ?? '',
        'Content-Type': 'application/json',
      },
    );
  }

  // POST 요청
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    if (_token == null) {
      await loadTokenFromStorage();
    }
    return http.post(
      Uri.parse(url),
      headers: {
        'Authorization': _token ?? '',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }
}
