import 'package:flutter/material.dart';
import 'package:tutorpus/pages/home_main.dart';
import 'package:tutorpus/pages/notifications.dart';
import 'package:tutorpus/pages/student_list.dart';
import 'package:tutorpus/pages/calendar_page.dart';

class HomeCommon extends StatefulWidget {
  const HomeCommon({super.key});

  @override
  State<HomeCommon> createState() => _HomeCommonState();
}

class _HomeCommonState extends State<HomeCommon> {
  int currentPageIndex = 0;
  int boo = 0;
  final List<Widget> screens = [
    const HomeMain(),
    const Noti(),
    const CalendarPage(),
    const StuList(),
  ];
  @override
  Widget build(BuildContext context) {
    if (boo == 0) {
      return Scaffold(
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'home'),
              NavigationDestination(
                  icon: Icon(Icons.notifications), label: 'noti'),
              NavigationDestination(
                  icon: Icon(Icons.calendar_month), label: 'calander'),
              NavigationDestination(icon: Icon(Icons.person), label: 'students')
            ],
            selectedIndex: currentPageIndex,
            onDestinationSelected: (int Index) {
              setState(() {
                currentPageIndex = Index;
              });
            },
          ),
          body: screens[currentPageIndex]);
    } else {
      return Scaffold(
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'home'),
              NavigationDestination(
                  icon: Icon(Icons.notifications), label: 'noti'),
              NavigationDestination(
                  icon: Icon(Icons.calendar_month), label: 'calander'),
              NavigationDestination(icon: Icon(Icons.person), label: 'teacher')
            ],
            selectedIndex: currentPageIndex,
            onDestinationSelected: (int Index) {
              setState(() {
                currentPageIndex = Index;
              });
            },
          ),
          body: screens[currentPageIndex]);
    }
  }
}
