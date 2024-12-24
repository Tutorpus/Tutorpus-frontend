import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutorpus/pages/home_main.dart';
import 'package:tutorpus/pages/notifications.dart';
import 'package:tutorpus/pages/student_list.dart';
import 'package:tutorpus/pages/calendar_page.dart';
import 'package:tutorpus/pages/login_main.dart'; // 로그인 페이지 import

class HomeCommon extends StatefulWidget {
  const HomeCommon({super.key});

  @override
  State<HomeCommon> createState() => _HomeCommonState();
}

class _HomeCommonState extends State<HomeCommon> {
  int currentPageIndex = 0;
  int boo = 0;

  final List<Widget> screens = [
    const HomeMain(),
    const Noti(),
    const CalendarPage(),
    const StuList(),
  ];

  @override
  void initState() {
    print('---------------Home common initState called');
    super.initState();
    _checkTokenAndFetchData();
  }

  /// SharedfPreferences에서 토큰 가져오기
  Future<String?> _getAuthToken() async {
    print('_getAuthToken called'); // 함수 호출 여부 확인
    final prefs = await SharedPreferences.getInstance();
    print('SharedPreferences instance retrieved'); // 인스턴스 가져왔는지 확인
    final token = prefs.getString('token');
    print('Stored Token: $token'); // 저장된 토큰 출력
    return token;
  }

  /// API 요청 시 헤더에 토큰 추가
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    if (token == null || token.isEmpty) {
      print('No token found');
      throw Exception('No token found');
    }
    return {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
  }

  /// API 호출 및 토큰 유효성 확인
  Future<void> _checkTokenAndFetchData() async {
    const String url =
        "http://ec2-43-201-11-102.ap-northeast-2.compute.amazonaws.com:8080/api/data";

    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        // 데이터 성공적으로 가져옴
        print('Protected Data: ${response.body}');
      } else if (response.statusCode == 401) {
        // 토큰 만료 또는 인증 실패
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('토큰이 만료되었습니다. 다시 로그인해주세요.')),
        );
        _navigateToLogin();
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      _navigateToLogin();
    }
  }

  /// 로그인 페이지로 이동
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginMain()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (boo == 0) {
      return Scaffold(
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'home'),
            NavigationDestination(
                icon: Icon(Icons.notifications), label: 'noti'),
            NavigationDestination(
                icon: Icon(Icons.calendar_month), label: 'calander'),
            NavigationDestination(icon: Icon(Icons.person), label: 'students'),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),
        body: screens[currentPageIndex],
      );
    } else {
      return Scaffold(
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'home'),
            NavigationDestination(
                icon: Icon(Icons.notifications), label: 'noti'),
            NavigationDestination(
                icon: Icon(Icons.calendar_month), label: 'calander'),
            NavigationDestination(icon: Icon(Icons.person), label: 'teacher'),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),
        body: screens[currentPageIndex],
      );
    }
  }
}
