import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutorpus/utils/api_client.dart';
import 'package:tutorpus/pages/login_main.dart'; // 로그인 페이지 import

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  String? userName; // 로그인된 유저 이름
  List<String> studentNames = []; // 연결된 학생 이름 목록
  bool isLoading = true; // 로딩 상태 관리

  @override
  void initState() {
    print('----------------Home Main--------------');
    super.initState();
    _loadUserData();
    print('initState called');
  }

  // SharedPreferences에서 토큰 가져오기
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    print('_getAuthToken called');
    return prefs.getString('token');
  }

  // SharedPreferences에서 유저 이름 가져오기
  Future<String?> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    print('_getUserName called');
    return prefs.getString('name');
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginMain()),
    );
  }

  // 1. SharedPreferences에서 유저 이름과 토큰 불러오기
  Future<void> _loadUserData() async {
    final token = await _getAuthToken(); // 저장된 토큰
    final name = await _getUserName(); // 저장된 유저 이름

    if (token != null && name != null) {
      setState(() {
        userName = name;
      });
      _fetchConnectedStudents(token);
      print('token is here');
      print('called the name: $userName'); // 학생 데이터 가져오기
    } else {
      print('No user data found, please login.');
      _navigateToLogin();
    }
  }

  Future<void> _fetchConnectedStudents(String token) async {
    const url = 'http://43.201.11.102:8080/student'; // 백엔드 API 주소
    final client = ApiClient();

    try {
      final response = await client.get(url);
      print('Authorization Header: $token');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          studentNames =
              data.map((student) => student['name'].toString()).toList();
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        print('Token expired. Redirecting to login.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Please login again.')),
        );
        _navigateToLogin();
      } else {
        print(
            'Failed to load student list: ${response.reasonPhrase} / body: ${response.body} / status code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 표시
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 로그인된 유저의 이름
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome, $userName!',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Connected Students:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                // 학생 목록 표시
                Expanded(
                  child: studentNames.isEmpty
                      ? const Center(child: Text('No students connected.'))
                      : ListView.builder(
                          itemCount: studentNames.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(studentNames[index]),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
