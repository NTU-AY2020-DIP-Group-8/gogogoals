import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:gogogoals/components/rounded_button.dart';
import 'package:gogogoals/pages/profile.dart';
import 'package:gogogoals/pages/profile.dart';
import 'package:gogogoals/services/auth.dart';
import 'dart:async';

import 'main_page.dart';
import 'add_task_screen.dart';

/*
void main() {
  runApp(MyApp());
}
*/
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  @override
  void initState() {
    super.initState();
  }

  int _currentIndex = 0;
  final List<Widget> _children = [
    MainScreen(),
    ProfileScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    print(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber[800],
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('New Todo'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
