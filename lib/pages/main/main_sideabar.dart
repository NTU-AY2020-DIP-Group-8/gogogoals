import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:gogogoals/pages/profile.dart';
import 'package:gogogoals/pages/logout_screen.dart';
import 'dart:async';

import 'main_page.dart';
import 'menu_widget.dart';

void main() {
  runApp(MyApp());
}

class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  String title;
  Widget t = MainScreen();

  @override
  void initState() {
    title = "GoGoGoals";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SliderMenuContainer(
            appBarColor: Colors.transparent,
            // appBarColor: Color(0x44000000),
            // isShadow: false,
            // appBarColor: Colors.green,
            key: _key,
            // appBarPadding: const EdgeInsets.only(top: 20),
            sliderMenuOpenOffset: 250,
            // appBarHeight: 60,
            title: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            sliderMenu: MenuWidget(
              onItemClick: (title, dest) {
                _key.currentState.closeDrawer();
                setState(() {
                  switch (dest) {
                    case "Home":
                      t = MainScreen();
                      break;
                    case "Profile":
                      t = ProfileScreen();
                      break;
                    case "Logout":
                      t = LogoutScreen();
                      break;
                  }
                });
              },
            ),
            sliderMain: t),
      ),
    );
  }
}
