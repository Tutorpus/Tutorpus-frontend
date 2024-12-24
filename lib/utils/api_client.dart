import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static String? _token;

  /// 토큰 설정 메서드
  static void setToken(String token) {
    _token = token;
  }

  /// SharedPreferences에서 토큰 로드
  static Future<void> loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    print('Loaded Token from Storage: $_token');
  }

  /// POST 요청 메서드
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    await _ensureTokenLoaded();

    try {
      print('POST Request URL: $url');
      print('POST Request Body: $body');
      return await http.post(
        Uri.parse(url),
        headers: _buildHeaders(),
        body: jsonEncode(body),
      );
    } catch (e) {
      print('POST Request Failed: $e');
      rethrow; // 예외를 호출 측으로 전달
    }
  }

  /// GET 요청 메서드
  Future<http.Response> get(String url) async {
    await _ensureTokenLoaded();

    try {
      print('GET Request URL: $url');
      return await http.get(
        Uri.parse(url),
        headers: _buildHeaders(),
      );
    } catch (e) {
      print('GET Request Failed: $e');
      rethrow; // 예외를 호출 측으로 전달
    }
  }

  /// 토큰이 로드되지 않았으면 로드
  Future<void> _ensureTokenLoaded() async {
    if (_token == null) {
      await loadTokenFromStorage();
    }
  }

  /// 공통 헤더 빌드
  Map<String, String> _buildHeaders() {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token'; // Bearer 키워드 추가
    }
    return headers;
  }
}
