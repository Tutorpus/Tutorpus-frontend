import 'package:flutter/material.dart';

class StudentDetail extends StatelessWidget {
  final int studentId; // studentId 정의

  const StudentDetail({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학생 상세 정보'),
      ),
      body: Center(
        child: Text('학생 ID: $studentId의 상세 정보를 표시합니다.'),
      ),
    );
  }
}
