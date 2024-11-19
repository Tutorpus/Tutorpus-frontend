import 'package:flutter/material.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:tutorpus/utils/input_field.dart';
import 'package:tutorpus/utils/oval_button.dart';

class SignupTch extends StatefulWidget {
  const SignupTch({super.key});

  @override
  State<SignupTch> createState() => _SignupTchState();
}

class _SignupTchState extends State<SignupTch> {
  _signup() {
    print('sign in presssed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
      ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Image.asset('assets/icons/octo_only_icon.png'),
                        const Text(
                          '만나서 반가워요!',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        const Text('회원 정보를 입력해주세요.',
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      inputField('이름을 입력해주세요'),
                      const SizedBox(
                        height: 20,
                      ),
                      inputField('이메일을 입력해주세요'),
                      const SizedBox(
                        height: 20,
                      ),
                      inputField('비밀번호를 입력해주세요'),
                      const SizedBox(
                        height: 40,
                      ),
                      OvalButton(
                        text: '회원가입하기',
                        backgroundColor: blue3,
                        textColor: white,
                        onPressed: _signup,
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
