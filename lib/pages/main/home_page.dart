import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:gogogoals/components/rounded_button.dart';
import 'package:gogogoals/pages/profile.dart';
import 'package:gogogoals/services/auth.dart';
import 'dart:async';

import 'main_page.dart';
import 'menu_widget.dart';

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
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  String title;
  Widget t = MainScreen();

  final AuthService _auth = AuthService();

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
            appBarHeight: 60,
            appBarPadding: const EdgeInsets.only(top: 20),
            title: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            sliderMenu: Container(
              child: Column(
                children: [
                  MenuWidget(
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
                        }
                      });
                    },
                  ),
                  Container(
                    height: 50.0,
                  ),
                  RoundedButton(
                    text: "LOGOUT",
                    press: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
            ),
            sliderMain: t),
      ),
    );
  }
}
