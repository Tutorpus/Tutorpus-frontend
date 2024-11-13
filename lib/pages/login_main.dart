import 'package:flutter/material.dart';
import 'package:tutorpus/utils/oval_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  void _login() {}

//로그인 함수 (진짜)
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

  void _signin() {}

  void _enter() {}

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
              Colors.lightBlueAccent,
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
                        child: loginField('email'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: loginField('password'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ovalButton('Log in', blue3, _login),
                ovalButton('Google Login', Colors.white, _login),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '아직 회원이 아니신가요?',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
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
                        //잠깐 들어갈 용도
                        onPressed: _enter,
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

  Padding ovalButton(String text, Color backgroundColor, Function function) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(backgroundColor),
          ),
          onPressed: () async {
            _login();
          },
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  TextFormField loginField(String text) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
