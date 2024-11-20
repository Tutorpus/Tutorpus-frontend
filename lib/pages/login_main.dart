import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutorpus/pages/home_common.dart';
import 'package:tutorpus/utils/oval_button.dart';
import 'package:tutorpus/utils/input_field.dart';
import 'package:tutorpus/pages/signin_mem_select.dart';

// import 경로 수정

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});
  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  void _login() {}

// 로그인 함수 (진짜)
  // void _login(String email, String password) {
  //   final url = "";
  //   final Map<String, dynamic> data = {
  //     'email': email,
  //     'password': password,
  //   }; // 서버로 데이터 전송

  // try {
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json'
  //     },
  //     body: {
  //       jsonEncode(data)
  //     }
  //   );
  // }
  // catch{

  // }
  // }

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
        width: double.infinity, // 가로로 화면 전체를 채움
        height: double.infinity, // 세로로 화면 전체를 채움
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue,
            ],
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
                        child: inputField('email'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: inputField('password'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                OvalButton(
                  text: 'Log in',
                  backgroundColor: blue,
                  textColor: Colors.black,
                  onPressed: _login,
                ),
                OvalButton(
                  text: 'Google Login',
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onPressed: _login,
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
                      )
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
