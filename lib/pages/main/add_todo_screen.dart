import 'dart:io' as io;

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
import 'package:gogogoals/components/todo_badge.dart';
import 'package:gogogoals/model/hero_id_model.dart';
import 'package:gogogoals/model/task_model.dart';
import 'package:gogogoals/model/todo_model.dart';
import 'package:gogogoals/scopedmodel/todo_list_model.dart';
import 'package:gogogoals/utils/color_utils.dart';
import 'package:gogogoals/utils/constants.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Rec>> fetchTask(String cat) async {
  final response = await http.get(
      'https://us-central1-dip-gr8.cloudfunctions.net/app/cat/' +
          cat.toLowerCase());

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    // var result = json.decode(response.body);
    return parseTasks(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<Course>> fetchCourse(String task, String cat) async {
  var response;

  if (cat != "course" && cat != "book" && cat != "recipe" && cat != "travel") {
    var apicheck = await http.get(
        'https://words.bighugelabs.com/api/2/75d5165665b1923827701a0e530d6ca6/' +
            cat.toLowerCase() +
            "/json?");
    // print(apicheck.body);
    Map<String, dynamic> result = jsonDecode(apicheck.body);
    String checklist = result["verb"]["syn"].toString();
    print(checklist);
    if (checklist.contains("learn")) {
      cat = "course";
    } else if (checklist.contains("read")) {
      cat = "book";
    } else if (checklist.contains("cook")) {
      cat = "recipe";
    } else if (checklist.contains("travel") || checklist.contains("visit")) {
      cat = "travel";
    }
  }
  if (cat == "course") {
    response = await http.get(
        'https://api.coursera.org/api/courses.v1?q=search&query=' +
            task.toLowerCase());
  } else if (cat == "book") {
    response = await http.get(
        'https://www.googleapis.com/books/v1/volumes?q=subject=' +
            task.toLowerCase());
  } else if (cat == "recipe") {
    response = await http.get(
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=8a368b785ac348199b09d5a3e89f7e55&fillIngredients=True&query=' +
            task.toLowerCase());
  } else if (cat == "travel") {
    response = await http.get(
        'https://www.triposo.com/api/20200803/poi.json?account=LZR64QHZ&token=sqh2dctwmo6n52e8nj73glevyomc9mvp&location_id=' +
            task.substring(0, 1).toUpperCase() +
            task.substring(1).toLowerCase());
  }

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    // var result = json.decode(response.body);
    return parseCourse(response.body, cat);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

// A function that converts a response body into a List<Photo>.
List<Rec> parseTasks(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Rec>((json) => Rec.fromJson(json)).toList();
}

class Rec {
  final String cat;
  final String content;

  Rec({this.cat, this.content});

  factory Rec.fromJson(Map<String, dynamic> json) {
    return Rec(
      cat: json['cat'],
      content: json['content'],
    );
  }
}

List<Course> parseCourse(String responseBody, String cat) {
  if (cat == "course") {
    var parsed =
        json.decode(responseBody)["elements"].cast<Map<String, dynamic>>();

    return parsed.map<Course>((json) => Course.fromJson(json)).toList();
  } else if (cat == "book") {
    var parsed =
        json.decode(responseBody)["items"].cast<Map<String, dynamic>>();

    return parsed.map<Course>((json) => Course.fromJsonBook(json)).toList();
  } else if (cat == "recipe") {
    var parsed = json
        .decode(responseBody)["results"][0]["missedIngredients"]
        .cast<Map<String, dynamic>>();

    return parsed.map<Course>((json) => Course.fromJsonRecipe(json)).toList();
  } else if (cat == "travel") {
    var parsed =
        json.decode(responseBody)["results"].cast<Map<String, dynamic>>();

    return parsed.map<Course>((json) => Course.fromJsonTravel(json)).toList();
  }
}

class Course {
  final String cat;
  final String content;

  Course({this.cat, this.content});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      cat: "https://www.coursera.org/learn/" + json['slug'],
      content: "Learn " + json['name'],
    );
  }

  factory Course.fromJsonBook(Map<String, dynamic> json) {
    return Course(
      cat: json['volumeInfo']['previewLink'],
      content: "Read " + json['volumeInfo']['title'],
    );
  }

  factory Course.fromJsonRecipe(Map<String, dynamic> json) {
    return Course(
      cat: "",
      content: "Buy " + json['name'],
    );
  }

  factory Course.fromJsonTravel(Map<String, dynamic> json) {
    return Course(
      cat: "",
      content: "Visit " + json['name'],
    );
  }
}

class AddTodoScreen extends StatefulWidget {
  final String taskId;
  final HeroId heroIds;
  final Task task;

  AddTodoScreen({
    @required this.taskId,
    @required this.heroIds,
    @required this.task,
  });

  @override
  State<StatefulWidget> createState() {
    return _AddTodoScreenState();
  }
}

final myController = TextEditingController();

class _AddTodoScreenState extends State<AddTodoScreen> {
  io.File pickedImage;
  var text = '';

  bool imageLoaded = false;

  Future pickImage() async {
    var awaitImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = awaitImage;
      imageLoaded = true;
    });
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            text = text + word.text + ' ';
          });
        }
        text = text + '\n';
      }
    }
    textRecognizer.close();

    print(text);
    myController.text = text;
    text = '';
  }

  String newTask;
  String url;
  DateTime deadline;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<List<Rec>> futureTask;
  Future<List<Course>> futureCourse;

  @override
  void initState() {
    super.initState();
    setState(() {
      newTask = '';
      url = '';
      myController.text = "";
    });
    futureTask = fetchTask(widget.task.name);
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return ScopedModelDescendant<TodoListModel>(
      builder: (BuildContext context, Widget child, TodoListModel model) {
        if (model.tasks.isEmpty) {
          // Loading
          return Container(
            color: Colors.white,
          );
        }

        var _task = model.tasks.firstWhere((it) => it.id == widget.taskId);
        var _color = ColorUtils.getColorFrom(id: _task.color);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'New Task',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.black26),
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
          body: Container(
            constraints: BoxConstraints.expand(height: 400),
            padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'What task are you planning to perform?',
                  style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
                Container(
                  height: 5.0,
                ),
                Container(
                  height: 80,
                  child: SingleChildScrollView(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: myController,
                      minLines: 1,
                      maxLines: null,
                      onChanged: (text) {
                        if (widget.task.name
                            .toLowerCase()
                            .contains("knowledge")) {
                          // knowledge cat

                          if (text.toLowerCase().contains("learn ")) {
                            String keywowrd = text;
                            keywowrd =
                                keywowrd.toLowerCase().replaceAll("learn ", "");
                            setState(() {
                              newTask = text;
                              futureCourse = fetchCourse(keywowrd, "course");
                            });
                          } else if (text.toLowerCase().contains("read ")) {
                            String keywowrd = text;
                            keywowrd =
                                keywowrd.toLowerCase().replaceAll("read ", "");
                            setState(() {
                              newTask = text;
                              futureCourse = fetchCourse(keywowrd, "book");
                            });
                          } else {
                            String keywowrd = text;
                            String cat = keywowrd.toLowerCase().split(" ")[0];
                            keywowrd = keywowrd.toLowerCase().split(" ")[1];
                            print(cat);
                            setState(() {
                              newTask = text;
                              futureCourse = fetchCourse(keywowrd, cat);
                            });
                          }
                        }
                        if (widget.task.name.toLowerCase().contains("meal")) {
                          // meal cat
                          if (text.toLowerCase().contains("cook ")) {
                            String keywowrd = text;
                            keywowrd =
                                keywowrd.toLowerCase().replaceAll("cook ", "");
                            setState(() {
                              newTask = text;
                              futureCourse = fetchCourse(keywowrd, "recipe");
                            });
                          } else {
                            String keywowrd = text;
                            String cat = keywowrd.toLowerCase().split(" ")[0];
                            keywowrd = keywowrd.toLowerCase().split(" ")[1];
                            print(cat);
                            setState(() {
                              newTask = text;
                              futureCourse = fetchCourse(keywowrd, cat);
                            });
                          }
                        }
                        if (widget.task.name.toLowerCase().contains("travel")) {
                          // meal travel
                          if (text.toLowerCase().contains("visit ")) {
                            String keywowrd = text;
                            keywowrd =
                                keywowrd.toLowerCase().replaceAll("visit ", "");
                            setState(() {
                              newTask = text;
                              futureCourse = fetchCourse(keywowrd, "travel");
                            });
                          } else {
                            String keywowrd = text;
                            var list = keywowrd.toLowerCase().split(" ");
                            String cat = list[0];
                            print(list);
                            if (list.length > 1 &&
                                list[list.length - 1] != null) {
                              keywowrd = list[list.length - 1];
                              print(cat + keywowrd);
                              setState(() {
                                newTask = text;
                                futureCourse = fetchCourse(keywowrd, cat);
                              });
                            }
                          }
                        } else {
                          setState(() => newTask = text);
                        }
                      },
                      cursorColor: _color,
                      // autofocus: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Your Task...',
                          hintStyle: TextStyle(
                            color: Colors.black26,
                          )),
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 36.0),
                    ),
                  ),
                ),
                Container(
                  height: 10.0,
                ),
                // Row(
                //   children: [
                //     TodoBadge(
                //       codePoint: _task.codePoint,
                //       color: _color,
                //       id: widget.heroIds.codePointId,
                //       size: 20.0,
                //     ),
                //     Container(
                //       width: 16.0,
                //     ),
                //     Hero(
                //       child: Text(
                //         _task.name,
                //         style: TextStyle(
                //           color: Colors.black38,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //       tag: "not_using_right_now", //widget.heroIds.titleId,
                //     ),
                //   ],
                // )

                //SizedBox(height: 10),
                widget.task.name.contains("Knowledge") ||
                        widget.task.name.contains("Meal") ||
                        widget.task.name.contains("Travel")
                    ? FutureBuilder<List<Course>>(
                        future: futureCourse,
                        builder: (context, snapshot) {
                          return new Container(
                              // alignment: FractionalOffset.centerLeft,
                              child: new Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                new FlatButton(
                                  color: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  disabledColor: kPrimaryColor,
                                  onPressed: () {
                                    myController.text = snapshot.hasData &&
                                            snapshot.data.length > 0
                                        ? snapshot.data[0].content
                                        : "Look up for youtube tutorials";
                                    setState(() {
                                      newTask = myController.text;
                                      url = snapshot.hasData &&
                                              snapshot.data.length > 0
                                          ? snapshot.data[0].cat
                                          : "";
                                    });
                                  },
                                  child: Text(
                                    snapshot.hasData && snapshot.data.length > 0
                                        ? snapshot.data[0].content
                                        : "Look up for youtube tutorials",
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
                                    myController.text = snapshot.hasData &&
                                            snapshot.data.length > 0
                                        ? snapshot.data[1].content
                                        : "Read up on a new topic";
                                    setState(() {
                                      newTask = myController.text;
                                      url = snapshot.hasData &&
                                              snapshot.data.length > 0
                                          ? snapshot.data[1].cat
                                          : "";
                                    });
                                  },
                                  child: Text(
                                    snapshot.hasData && snapshot.data.length > 0
                                        ? snapshot.data[1].content
                                        : "Read up on a new topic",
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
                                    myController.text = snapshot.hasData &&
                                            snapshot.data.length > 0
                                        ? snapshot.data[2].content
                                        : "Make a summary of relevant notes";
                                    setState(() {
                                      newTask = myController.text;
                                      url = snapshot.hasData &&
                                              snapshot.data.length > 0
                                          ? snapshot.data[2].cat
                                          : "";
                                    });
                                  },
                                  child: Text(
                                    snapshot.hasData && snapshot.data.length > 0
                                        ? snapshot.data[2].content
                                        : "Make a summary of relevant notes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                              ]));
                        })
                    : FutureBuilder<List<Rec>>(
                        future: futureTask,
                        builder: (context, snapshot) {
                          return new Container(
                              // alignment: FractionalOffset.centerLeft,
                              child: new Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                new FlatButton(
                                  color: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  disabledColor: kPrimaryColor,
                                  onPressed: () {
                                    myController.text = snapshot.hasData
                                        ? snapshot.data[0].content
                                        : "Todo1";
                                    setState(() => newTask = myController.text);
                                  },
                                  child: Text(
                                    snapshot.hasData
                                        ? snapshot.data[0].content
                                        : "Todo1",
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
                                    myController.text = snapshot.hasData
                                        ? snapshot.data[1].content
                                        : "Todo2";
                                    setState(() => newTask = myController.text);
                                  },
                                  child: Text(
                                    snapshot.hasData
                                        ? snapshot.data[1].content
                                        : "Todo2",
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
                                    myController.text = snapshot.hasData
                                        ? snapshot.data[2].content
                                        : "Todo3";
                                    setState(() => newTask = myController.text);
                                  },
                                  child: Text(
                                    snapshot.hasData
                                        ? snapshot.data[2].content
                                        : "Todo3",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                              ]));
                        }),
                RaisedButton(
                  child: deadline == null
                      ? Text(
                          'Pick a date to finish it',
                        )
                      : Text('by ' + deadline.toString().split(" ")[0]),
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030))
                        .then((selectedDate) {
                      setState(() => deadline = selectedDate);
                    });
                  },
                  color: Colors.green,
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    Center(
                      child: FlatButton.icon(
                        icon: Icon(
                          Icons.photo_camera,
                          size: 36,
                        ),
                        label: Text(''),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () async {
                          pickImage();
                        },
                      ),
                    ),
                  ],
                ),
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
                            heroTag: 'fab_new_task',
                            child: Icon(
                              Icons.add,
                              size: 30.0,
                            ),
                            backgroundColor: _color,
                            onPressed: () {
                              if (newTask.isEmpty) {
                                final snackBar = SnackBar(
                                  content: Text(
                                      'Ummm... It seems that you are trying to add an invisible task which is not allowed in this realm.'),
                                  backgroundColor: _color,
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                                // _scaffoldKey.currentState.showSnackBar(snackBar);
                              } else {
                                LineSplitter ls = new LineSplitter();
                                List<String> tasks = ls.convert(newTask);
                                for (var i = 0; i < tasks.length; i++) {
                                  if (tasks[i] != "") {
                                    model.addTodo(Todo(
                                      tasks[i],
                                      url: url,
                                      parent: _task.id,
                                      deadline: deadline,
                                    ));
                                  }
                                }
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  : FloatingActionButton.extended(
                      hoverElevation: 5.0,
                      heroTag: 'fab_new_task',
                      icon: Icon(Icons.add),
                      backgroundColor: _color,
                      label: Text('Create Task'),
                      onPressed: () {
                        if (newTask.isEmpty) {
                          final snackBar = SnackBar(
                            content: Text(
                                'Ummm... It seems that you are trying to add an invisible task which is not allowed in this realm.'),
                            backgroundColor: _color,
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                          // _scaffoldKey.currentState.showSnackBar(snackBar);
                        } else {
                          model.addTodo(Todo(
                            newTask,
                            url: url,
                            parent: _task.id,
                            deadline: deadline,
                          ));
                          Navigator.pop(context);
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
