import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutorpus/pages/home_common.dart';
import 'package:tutorpus/utils/oval_button.dart';
import 'package:tutorpus/utils/input_field.dart';
import 'package:tutorpus/pages/signin_mem_select.dart';

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  // TextEditingController 초기화
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 로그인 함수
  Future<void> _login(String email, String password) async {
    const String url =
        "http://ec2-43-201-11-102.ap-northeast-2.compute.amazonaws.com:8080/member/login";

    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('로그인 성공: ${responseData['token']}');

        // 홈 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeCommon()),
        );
      } else {
        // 실패 시 서버 응답 메시지 출력
        final errorData = jsonDecode(response.body);
        print('로그인 실패: ${errorData['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: ${errorData['message']}')),
        );
      }
    } catch (e) {
      // 네트워크 또는 기타 에러 처리
      print('에러 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('서버 연결 중 에러가 발생했습니다.')),
      );
    }
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      _login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일과 비밀번호를 모두 입력해주세요.')),
      );
    }
  }

  void _signin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SigninMemSelect()),
    );
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
                          obscureText: true, // 비밀번호 입력 시 숨김 처리
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                OvalButton(
                  text: 'Log in',
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  onPressed: _handleLogin,
                ),
                OvalButton(
                  text: 'Google Login',
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    // Google 로그인 구현은 나중에 추가
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google 로그인 기능은 준비 중입니다.')),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '아직 회원이 아니신가요?',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      TextButton(
                        onPressed: _signin,
                        child: const Text(
                          "회원가입",
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeCommon()),
                          );
                        },
                        child: const Text(
                          "가짜",
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
