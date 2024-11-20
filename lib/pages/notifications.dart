import 'package:flutter/material.dart';
import 'package:tutorpus/theme/colors.dart';

class Noti extends StatefulWidget {
  const Noti({super.key});

  @override
  State<Noti> createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('notifications'),
      ),
      body: Container(
        width: double.infinity, // 가로로 화면 전체를 채움
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              NotificationBox(
                  title: 'Meeting Reminder',
                  detail: '내일 수업이 있어요',
                  time: '2 hours ago',
                  type: 'meeting'),
            ],
          ),
        ),
      ),
    );
  }

  Padding NotificationBox({
    required String title,
    required String detail,
    required String time,
    required String type, // 알림 타입 추가
  }) {
    // 타입에 따른 이미지 경로 설정
    String imagePath;
    switch (type) {
      case 'meeting':
        imagePath = 'assets/images/meeting.png';
        break;
      case 'homework':
        imagePath = 'assets/images/homework.png';
        break;
      case 'event':
        imagePath = 'assets/images/event.png';
        break;
      default:
        imagePath = 'assets/images/default.png'; // 기본 이미지
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: lightblue,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    imagePath, // 동적으로 설정된 이미지 경로
                    width: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          detail,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
