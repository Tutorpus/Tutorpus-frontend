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
                  title: '내일 수업 알림',
                  detail: '내일 수업이 있어요',
                  time: '2 hours ago',
                  type: 'calendar'),
              NotificationBox(
                  title: '숙제 알림',
                  detail: '복지희 학생이 숙제를 완료했어요.',
                  time: '2 hours ago',
                  type: 'homework'),
              NotificationBox(
                  title: '피드백 알림',
                  detail: '선생님이 피드백을 남겼어요!',
                  time: '2 hours ago',
                  type: 'feedback'),
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
      case 'homework':
        imagePath = 'assets/images/homework.png';
        break;
      case 'feedback':
        imagePath = 'assets/images/feedback.png';
        break;
      default:
        'calendar';
        imagePath = 'assets/images/calendar.png'; // 기본 이미지
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
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Image.asset(
                      imagePath, // 동적으로 설정된 이미지 경로
                      width: 30,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45.0),
                child: Text(
                  detail,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
