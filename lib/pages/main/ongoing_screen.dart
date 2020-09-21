import 'package:flutter/material.dart';
import 'package:gogogoals/scopedmodel/todo_list_model.dart';
import 'package:gogogoals/utils/color_utils.dart';
import 'package:scoped_model/scoped_model.dart';

class OngoingScreen extends StatefulWidget {
  OngoingScreen();

  @override
  State<StatefulWidget> createState() {
    return _OngoingScreenState();
  }
}

class _OngoingScreenState extends State<OngoingScreen> {
  String newTask;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color taskColor;
  IconData taskIcon;

  @override
  void initState() {
    super.initState();
    setState(() {
      newTask = '';
      taskColor = ColorUtils.defaultColors[0];
      taskIcon = Icons.work;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
      builder: (BuildContext context, Widget child, TodoListModel model) {
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Ongoing',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black26),
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
          ),
          body: Container(
              // constraints: BoxConstraints.expand(),
              ),
        );
      },
    );
  }
}
// Reason for wraping fab with builder (to get scafold context)
// https://stackoverflow.com/a/52123080/4934757
