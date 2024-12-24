import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_common.dart';
import 'package:tutorpus/utils/oval_button.dart';
import 'package:tutorpus/utils/input_field.dart';
import 'package:tutorpus/utils/api_client.dart'; // ApiClient import

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkExistingToken();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 기존 토큰 확인 및 자동 로그인 처리
  Future<void> _checkExistingToken() async {
    final token = await _loadAuthToken();
    if (token != null) {
      // ApiClient에 토큰 등록
      ApiClient.setToken(token);

      // 홈 화면으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeCommon()),
      );
    }
  }

  /// 로그인 요청 처리
  Future<void> _login(String email, String password) async {
    const String url =
        "http://ec2-43-201-11-102.ap-northeast-2.compute.amazonaws.com:8080/member/login";

    try {
      setState(() => _isLoading = true);

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      print('===============로그인 성공===============');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String token = responseData['token'];
        final String name = responseData['name']; // 사용자 이름
        print('로그인 성공');

        // SharedPreferences에 토큰과 사용자 이름 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token); // 순수 토큰 저장
        await prefs.setString('name', name); // 사용자 이름 저장

// ApiClient에 토큰 등록
        ApiClient.setToken(token);

        // 홈 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeCommon()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 실패. 이메일 또는 비밀번호를 확인하세요.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('서버 연결 중 에러가 발생했습니다.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// SharedPreferences에 토큰 저장
  Future<void> _saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  /// SharedPreferences에서 토큰 불러오기
  Future<String?> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일과 비밀번호를 모두 입력해주세요.')),
      );
      return;
    }

    _login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Image.asset('assets/images/main_logo.png'),
                const SizedBox(height: 50),
                Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: inputField(
                          'email',
                          controller: _emailController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: inputField(
                          'password',
                          controller: _passwordController,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator()
                    : OvalButton(
                        text: 'Log in',
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        onPressed: _handleLogin,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
