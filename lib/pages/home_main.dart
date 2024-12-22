import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    super.initState();
    _loadUserData();
    Future<void> checkSharedPreferences() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final name = prefs.getString('name');

      print('Token: $token');
      print('Name: $name');
    }
  }

  // 1. SharedPreferences에서 유저 이름과 토큰 불러오기
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // 저장된 토큰
    final name = prefs.getString('name'); // 저장된 유저 이름

    if (token != null && name != null) {
      setState(() {
        userName = name;
      });
      _fetchConnectedStudents(token); // 학생 데이터 가져오기
    } else {
      print('No user data found, please login.');
      setState(() {
        isLoading = false;
      });
    }
  }

  // 2. 백엔드에서 연결된 학생 목록 가져오기
  Future<void> _fetchConnectedStudents(String token) async {
    const url = 'http://43.201.11.102:8080/connected-students'; // 백엔드 API 주소

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // 인증 토큰 추가
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          studentNames =
              data.map((student) => student['name'].toString()).toList();
          isLoading = false;
        });
      } else {
        print(
            'Failed to load student list: ${response.reasonPhrase} /n body: ${response.body} /n ${response.statusCode}');
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
