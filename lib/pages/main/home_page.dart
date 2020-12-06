import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:gogogoals/components/rounded_button.dart';
import 'package:gogogoals/model/user_model.dart';
import 'package:gogogoals/pages/profile.dart';
import 'package:gogogoals/pages/profile.dart';
import 'package:gogogoals/scopedmodel/todo_list_model.dart';
import 'package:gogogoals/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

import 'main_page.dart';
import 'add_task_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Guser>(context);
    return ScopedModel<TodoListModel>(
      model: user.model,
      child: MaterialApp(
        title: 'Gogogoals',
        debugShowCheckedModeBanner: false,
        home: HomeS(),
      ),
    );
  }
}

class HomeS extends StatefulWidget {
  HomeS({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeS> {
  int _currentIndex;
  List<Widget> _children;

  void goHome() {
    setState(() {
      _currentIndex = 0;
      print("asa");
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _children = [
      MainScreen(),
      AddTaskScreen(notifyParent: goHome),
      ProfileScreen()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    print(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
        builder: (BuildContext context, Widget child, TodoListModel model) {
      return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.amber[800],
          items: [
            new BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30.0,
              ),
              title: Text('Home'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                size: 30.0,
              ),
              title: Text('Add New Goal'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(
                Icons.account_box,
                size: 30.0,
              ),
              title: Text('Profile'),
            ),
          ],
        ),
      );
    });
  }
}
