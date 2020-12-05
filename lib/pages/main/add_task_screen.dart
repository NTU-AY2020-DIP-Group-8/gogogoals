import 'package:flutter/material.dart';
import 'package:gogogoals/components/colorpicker/color_picker_builder.dart';
import 'package:gogogoals/components/iconpicker/icon_picker_builder.dart';
import 'package:gogogoals/components/rounded_button.dart';
import 'package:gogogoals/model/category_model.dart';
import 'package:gogogoals/model/task_model.dart';
import 'package:gogogoals/pages/main/main_page.dart';
import 'package:gogogoals/scopedmodel/todo_list_model.dart';
import 'package:gogogoals/utils/color_utils.dart';
import 'package:gogogoals/utils/constants.dart';
import 'package:scoped_model/scoped_model.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen();

  @override
  State<StatefulWidget> createState() {
    return _AddTaskScreenState();
  }
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String newTask;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color taskColor;
  IconData taskIcon;

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      newTask = '';
      myController.text = "";
      taskColor = ColorUtils.defaultColors[0];
      taskIcon = Icons.work;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return ScopedModelDescendant<TodoListModel>(
      builder: (BuildContext context, Widget child, TodoListModel model) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          backgroundColor: Colors.cyan[50],
          appBar: AppBar(
            title: Text(
              'New Category',
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
            padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category will help you group related task!',
                  style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
                Container(
                  height: 16.0,
                ),
                TextField(
                  controller: myController,
                  onChanged: (text) {
                    setState(() => newTask = text);
                  },
                  cursorColor: taskColor,
                  autofocus: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Category Name...',
                      hintStyle: TextStyle(
                        color: Colors.black26,
                      )),
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 36.0),
                ),
                Container(
                  height: 26.0,
                ),
                // Row(
                //   children: [
                //     ColorPickerBuilder(
                //         color: taskColor,
                //         onColorChanged: (newColor) =>
                //             setState(() => taskColor = newColor)),
                //     Container(
                //       width: 22.0,
                //     ),
                //     IconPickerBuilder(
                //         iconData: taskIcon,
                //         highlightColor: taskColor,
                //         action: (newIcon) =>
                //             setState(() => taskIcon = newIcon)),
                //   ],
                // ),

                new Container(
                    alignment: FractionalOffset.center,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new FlatButton(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            disabledColor: kPrimaryColor,
                            onPressed: () {
                              myController.text = "Health";
                              setState(() => newTask = myController.text);
                            },
                            child: Text(
                              "Health",
                              style: TextStyle(color: Colors.white),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                          new FlatButton(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            disabledColor: kPrimaryColor,
                            onPressed: () {
                              myController.text = "Wealth";
                              setState(() => newTask = myController.text);
                            },
                            child: Text(
                              "Wealth",
                              style: TextStyle(color: Colors.white),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                        ])),

                new Container(
                    alignment: FractionalOffset.center,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new FlatButton(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            disabledColor: kPrimaryColor,
                            onPressed: () {
                              myController.text = "Knowledge";
                              setState(() => newTask = myController.text);
                            },
                            child: Text(
                              "Knowledge",
                              style: TextStyle(color: Colors.white),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                          new FlatButton(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            disabledColor: kPrimaryColor,
                            onPressed: () {
                              myController.text = "Travel";
                              setState(() => newTask = myController.text);
                            },
                            child: Text(
                              "Travel",
                              style: TextStyle(color: Colors.white),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                        ])),

                new Container(
                    alignment: FractionalOffset.center,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new FlatButton(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            disabledColor: kPrimaryColor,
                            onPressed: () {
                              myController.text = "Work";
                              setState(() => newTask = myController.text);
                            },
                            child: Text(
                              "Work",
                              style: TextStyle(color: Colors.white),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                          new FlatButton(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            disabledColor: kPrimaryColor,
                            onPressed: () {
                              myController.text = "Meal";
                              setState(() => newTask = myController.text);
                            },
                            child: Text(
                              "Meal",
                              style: TextStyle(color: Colors.white),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                        ])),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Builder(
            builder: (BuildContext context) {
              return (keyboardIsOpened)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0),
                          child: FloatingActionButton(
                            hoverElevation: 5.0,
                            heroTag: 'fab_new_card',
                            child: Icon(Icons.add, size: 44.0),
                            backgroundColor: taskColor,
                            onPressed: () {
                              if (newTask.isEmpty) {
                                final snackBar = SnackBar(
                                  content: Text(
                                      'Ummm... It seems that you are trying to add an invisible task which is not allowed in this realm.'),
                                  backgroundColor: taskColor,
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                                // _scaffoldKey.currentState.showSnackBar(snackBar);
                              } else {
                                model.addTask(Task(newTask,
                                    parent: "categorydummyID",
                                    codePoint: taskIcon.codePoint,
                                    color: taskColor.value,
                                    status: 0));
                                //Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  : FloatingActionButton.extended(
                      hoverElevation: 5.0,
                      heroTag: 'fab_new_card',
                      icon: Icon(
                        Icons.add_circle,
                        size: 25.0,
                      ),
                      backgroundColor: taskColor,
                      label: Text('Create New Card'),
                      onPressed: () {
                        if (newTask.isEmpty) {
                          final snackBar = SnackBar(
                            content: Text(
                                'Ummm... It seems that you are trying to add an invisible task which is not allowed in this realm.'),
                            backgroundColor: taskColor,
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                          // _scaffoldKey.currentState.showSnackBar(snackBar);
                        } else {
                          final snackBar = SnackBar(
                            content: Text(
                                'New category has been created successfully!'),
                            backgroundColor: taskColor,
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                          // _scaffoldKey.currentState.showSnackBar(snackBar);
                          model.addTask(Task(newTask,
                              parent: "categorydummyID",
                              codePoint: taskIcon.codePoint,
                              color: taskColor.value,
                              status: 0));
                        }
                      },
                    );
            },
          ),
        );
      },
    );
  }
}
// Reason for wraping fab with builder (to get scafold context)
// https://stackoverflow.com/a/52123080/4934757
