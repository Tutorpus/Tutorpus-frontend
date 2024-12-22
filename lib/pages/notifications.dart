import 'package:flutter/material.dart';
import 'package:tutorpus/theme/colors.dart';

class Noti extends StatefulWidget {
  const Noti({super.key});

  @override
  State<Noti> createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  // 알림 데이터를 저장할 리스트
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadFakeNotifications(); // 가짜 알림 데이터 로드
  }

  // 가짜 알림 데이터 로드 함수
  void _loadFakeNotifications() {
    setState(() {
      notifications = [
        NotificationModel(
          title: '수업 알림',
          detail: '내일 오전 10시에 수업이 있습니다.',
          time: '2시간 전',
          type: 'calendar',
        ),
        NotificationModel(
          title: '숙제 알림',
          detail: '복지희 학생이 숙제를 완료했습니다.',
          time: '어제',
          type: 'homework',
        ),
        NotificationModel(
          title: '피드백 알림',
          detail: '최윤서 학생에게 피드백을 남겼습니다.',
          time: '3일 전',
          type: 'feedback',
        ),
        NotificationModel(
          title: '수업 알림',
          detail: '내일 오전 10시에 수업이 있습니다.',
          time: '1주일 전',
          type: 'calendar',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: notifications.isEmpty
            ? const Center(
                child: Text(
                  '알림이 없습니다!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ) // 알림이 없을 때 메시지 표시
            : SingleChildScrollView(
                child: Column(
                  children: notifications.map((notification) {
                    return NotificationBox(
                      title: notification.title,
                      detail: notification.detail,
                      time: notification.time,
                      type: notification.type,
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }

  Padding NotificationBox({
    required String title,
    required String detail,
    required String time,
    required String type,
  }) {
    String imagePath;

    // 타입에 따른 이미지 경로 설정
    switch (type) {
      case 'homework':
        imagePath = 'assets/images/homework.png';
        break;
      case 'feedback':
        imagePath = 'assets/images/feedback.png';
        break;
      default:
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
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Image.asset(
                      imagePath,
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

// 알림 데이터 모델 클래스
class NotificationModel {
  final String title;
  final String detail;
  final String time;
  final String type;

  NotificationModel({
    required this.title,
    required this.detail,
    required this.time,
    required this.type,
  });
}
