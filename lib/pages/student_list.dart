import 'package:flutter/material.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:tutorpus/pages/student_detail.dart';

class Student {
  final int id;
  final String name;
  final String school;
  final String subject;

  Student({
    required this.id,
    required this.name,
    required this.school,
    required this.subject,
  });
}

class StuList extends StatefulWidget {
  const StuList({super.key});

  @override
  State<StuList> createState() => _StuListState();
}

class _StuListState extends State<StuList> {
  final List<Student> students = [
    Student(id: 1, name: '복지희', school: '초4', subject: '수학'),
    Student(id: 2, name: '이준영', school: '중2', subject: '영어'),
    Student(id: 3, name: '김수진', school: '고1', subject: '과학'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('students'),
          backgroundColor: Colors.white, // 배경색을 투명으로 설정
          elevation: 0,
        ),
        body: Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return stuBoxBtn(context, student.name, student.subject,
                    student.school, student.id);
              },
            )));
  }

  InkWell stuBoxBtn(BuildContext context, String name, String subject,
      String school, int id) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StudentDetail(studentId: id)));
      },
      child: stuBox(name, subject, school, id),
    );
  }

  Padding stuBox(String name, String subject, String school, int id) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: lightblue,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Image.asset(
                    'assets/images/feedback.png',
                    width: 50,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      //태그 줄줄
                      children: [listAttr(school), listAttr(subject)],
                    )
                  ],
                )
              ],
            )));
  }

  Text listAttr(String attr) {
    return Text('#' '$attr ',
        style: const TextStyle(
          fontSize: 18,
        ));
  }
}
