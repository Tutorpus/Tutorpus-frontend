import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // 컬러 픽커 패키지
import 'package:tutorpus/pages/student_detail.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:tutorpus/utils/api_client.dart';

class Student {
  final int connectId;
  final String name;
  final String school;
  final String subject;
  //final String color;

  Student({
    required this.connectId,
    required this.name,
    required this.school,
    required this.subject,
    // required this.color,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      connectId: json['connectId'],
      name: json['name'],
      school: json['school'],
      subject: json['subject'],
      //color: json['color'],
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

  // ApiClient를 이용해 학생 데이터를 가져오는 메서드
  Future<void> _fetchStudentList() async {
    const url = 'http://43.201.11.102:8080/student'; // API URL

    try {
      final client = ApiClient(); // ApiClient 인스턴스 생성
      final response = await client.get(url); // GET 요청

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        print('--------------students------------');
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

  Future<void> _addStudent(
    String name,
    String school,
    String subject,
    String email,
    List<Map<String, String>> timeSlots,
    //String color,
  ) async {
    const url = 'http://43.201.11.102:8080/student';

    try {
      final client = ApiClient();
      final response = await client.post(
        url,
        {
          "name": name,
          "school": school,
          "subject": subject,
          "studentEmail": email,
          "timeSlots": timeSlots,
          //"color": color,
        },
      );
      print('-------------------------------------');
      print('Response status: ${response.statusCode}');
      print('Request Body: ${jsonEncode({
            "name": name,
            "school": school,
            "subject": subject,
            "studentEmail": email,
            "timeSlots": timeSlots,
            //  "color": color,
          })}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));
        final newStudent = Student.fromJson(responseData);

        setState(() {
          students.add(newStudent);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student added successfully!')),
          );
        }
      } else if (response.statusCode == 403) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('권한이 없습니다. 다시 로그인해주세요.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        print('Failed to add student: ${response.reasonPhrase}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to add student: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      print('Error adding student: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding student: $e')),
        );
      }
    }
  }

  void _showAddStudentDialog() {
    final nameController = TextEditingController();
    final schoolController = TextEditingController();
    final subjectController = TextEditingController();
    final emailController = TextEditingController();
    List<Map<String, String>> timeSlots = [];
    Color selectedColor = Colors.blue; // Default color

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void addTimeSlot() {
              timeSlots.add(
                  {"day": "MON", "startTime": "09:00", "endTime": "11:00"});
              setState(() {});
            }

            void updateTimeSlot(int index, String key, String value) {
              timeSlots[index][key] = value;
              setState(() {});
            }

            void removeTimeSlot(int index) {
              timeSlots.removeAt(index);
              setState(() {});
            }

            return AlertDialog(
              title: const Text('Add New Student'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: schoolController,
                      decoration: const InputDecoration(labelText: 'School'),
                    ),
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(labelText: 'Subject'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Time Slots:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...timeSlots.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final timeSlot = entry.value;
                        return Row(
                          children: [
                            DropdownButton<String>(
                              value: timeSlot["day"],
                              onChanged: (value) =>
                                  updateTimeSlot(index, "day", value!),
                              items: [
                                "MON",
                                "TUE",
                                "WED",
                                "THU",
                                "FRI",
                                "SAT",
                                "SUN"
                              ]
                                  .map((day) => DropdownMenuItem(
                                      value: day, child: Text(day)))
                                  .toList(),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                    labelText: 'Start Time'),
                                controller: TextEditingController(
                                    text: timeSlot["startTime"]),
                                onSubmitted: (value) =>
                                    updateTimeSlot(index, "startTime", value),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                    labelText: 'End Time'),
                                controller: TextEditingController(
                                    text: timeSlot["endTime"]),
                                onSubmitted: (value) =>
                                    updateTimeSlot(index, "endTime", value),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () => removeTimeSlot(index),
                            ),
                          ],
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: addTimeSlot,
                      child: const Text('Add Time Slot'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    //final hexColor =
                    //    '#${selectedColor.value.toRadixString(16).substring(2)}';
                    _addStudent(
                      nameController.text,
                      schoolController.text,
                      subjectController.text,
                      emailController.text,
                      timeSlots,
                      // hexColor,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Students'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
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
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddStudentDialog, // 다이얼로그 표시
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add, // + 아이콘
            color: Colors.white, // 아이콘 색상
            size: 36, // 아이콘 크기
          ),
        ));
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
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: SizedBox(
                width: 50,
                height: 50,
                // decoration: BoxDecoration(
                //   color:
                //       Color(int.parse(student.color.replaceFirst('#', '0xff'))),
                //   shape: BoxShape.circle,
                // ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
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
