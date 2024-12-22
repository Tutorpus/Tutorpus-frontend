import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static String? _token;

  // 토큰 설정 메서드
  static void setToken(String token) {
    _token = token;
  }

  // SharedPreferences에서 토큰 로드
  static Future<void> loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  // POST 요청 메서드
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    if (_token == null) {
      await loadTokenFromStorage(); // 토큰 로드
    }
    print('POST == Authorization Token: $_token');
    return await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': _token ?? '', // 인증 토큰 추가
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  // GET 요청 메서드 (기존 사용)
  Future<http.Response> get(String url) async {
    if (_token == null) {
      await loadTokenFromStorage(); // 토큰 로드
    }
    print('GET == Authorization Token: $_token');

    return await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': _token ?? '', // 인증 토큰 추가
        'Content-Type': 'application/json',
      },
    );
  }
}
