import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomNavigationBar: NavigationBar(
        destinations: [
          Container(color: Colors.green),
          Container(color: Colors.amber),
          Container(color: Colors.yellow),
          Container(color: Colors.red),
        ],
      ),
    );
  }
}
