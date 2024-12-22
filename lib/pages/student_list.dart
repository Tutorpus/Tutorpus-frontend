import 'package:flutter/material.dart';
import 'package:tutorpus/pages/student_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorpus/theme/colors.dart';

class Student {
  final int connectId;
  final String name;
  final String school;
  final String iconPath;
  final String subject;
  final String color;

  Student({
    required this.connectId,
    required this.name,
    required this.school,
    required this.iconPath,
    required this.subject,
    required this.color,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      connectId: json['connectId'],
      name: json['name'],
      school: json['school'],
      iconPath: json['iconPath'],
      subject: json['subject'],
      color: json['color'],
    );
  }
}

class StuList extends StatefulWidget {
  const StuList({super.key});

  @override
  State<StuList> createState() => _StuListState();
}

class _StuListState extends State<StuList> {
  List<Student> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudentList(); // 백엔드에서 데이터를 가져옵니다.
  }

  // 백엔드에서 학생 데이터를 가져오는 메서드
  Future<void> _fetchStudentList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // 저장된 토큰 가져오기

    if (token == null) {
      print('Token not found');
      setState(() {
        isLoading = false;
      });
      return;
    }

    const url = 'http://43.201.11.102:8080/connected-students'; // API URL

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          students = data.map((json) => Student.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        print(
            'Failed to fetch students: ${response.reasonPhrase} code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching students: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 상태
          : students.isEmpty
              ? const Center(child: Text('No students found')) // 학생 데이터 없음
              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentDetail(studentId: student.connectId),
                          ),
                        );
                      },
                      child: _stuBox(student),
                    );
                  },
                ),
    );
  }

  Padding _stuBox(Student student) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: lightblue,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.network(
                'http://43.201.11.102:8080${student.iconPath}',
                width: 50,
                height: 50,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.account_circle,
                  size: 50,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    _listAttr(student.school),
                    _listAttr(student.subject)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Text _listAttr(String attr) {
    return Text(
      '#$attr ',
      style: const TextStyle(fontSize: 16, color: Colors.black54),
    );
  }
}
