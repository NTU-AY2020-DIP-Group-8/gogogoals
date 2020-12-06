import 'package:flutter/material.dart';
import 'package:gogogoals/services/auth.dart';
import 'package:gogogoals/utils/color_utils.dart';
import 'package:gogogoals/utils/constants.dart';
import 'package:gogogoals/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:gogogoals/scopedmodel/todo_list_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Guser>(context);
    return ScopedModel<TodoListModel>(
      model: user.model,
      child: MaterialApp(
        title: 'Gogogoals',
        debugShowCheckedModeBanner: false,
        home: ProfilePage(),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
        builder: (BuildContext context, Widget child, TodoListModel model) {
      var _todos = model.todos;
      _todos.sort((a, b) {
        if (a.deadline == null && b.deadline == null)
          return 0;
        else if (b.deadline == null)
          return -1;
        else if (a.deadline == null) return 1;
        return a.deadline.compareTo(b.deadline);
      });

      //_todos.sort((a, b) {
      //  return a.isCompleted.compareTo(b.isCompleted);
      //});

      var _color = ColorUtils.getColorFrom(id: 3);
      return Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
          title: Text(""),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 20,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Column(children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(
                      icon: Icon(Icons.input),
                      onPressed: () => _auth.signOut(),
                    ),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    CircleAvatar(
                      backgroundImage:
                          // NetworkImage(
                          //   "https://www.trendrr.net/wp-content/uploads/2017/06/Deepika-Padukone-1.jpg",
                          // ),
                          AssetImage('assets/images/profile_placeholder.jpg'),
                      radius: 50.0,
                    ),
                  ]),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Meow",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Dream BIG, Work HARD",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 22.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Completed",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  _todos
                                      .where((todo) => todo.isCompleted == 1)
                                      .length
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.pinkAccent,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Upcoming",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  _todos
                                      .where((todo) => todo.isCompleted == 0)
                                      .length
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.pinkAccent,
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Expanded(
                          //   child: Column(
                          //     children: [
                          //       Text(
                          //         "Streak",
                          //         style: TextStyle(
                          //           color: Colors.black54,
                          //           fontSize: 14.0,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 5.0,
                          //       ),
                          //       Text(
                          //         "4",
                          //         style: TextStyle(
                          //           fontSize: 20.0,
                          //           color: Colors.pinkAccent,
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    if (index == _todos.length) {
                      return SizedBox(
                        height: 50, // size of FAB
                      );
                    }
                    var todo = _todos[index];
                    return Container(
                      padding: EdgeInsets.only(left: 22.0, right: 22.0),
                      child: ListTile(
                        onTap: () {
                          model.updateTodo(
                            todo.copy(
                                isCompleted: todo.isCompleted == 1 ? 0 : 1),
                          );
                        },
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                        leading: Checkbox(
                            onChanged: (value) => model.updateTodo(
                                  todo.copy(isCompleted: value ? 1 : 0),
                                ),
                            value: todo.isCompleted == 1 ? true : false),
                        trailing: Wrap(
                          children: <Widget>[
                            todo.url != "" && todo.url != null
                                ? IconButton(
                                    icon: Icon(Icons.link),
                                    onPressed: () {
                                      launchURL(String url) async {
                                        if (await canLaunch(url)) {
                                          await launch(
                                            url,
                                            // forceWebView: true,
                                          );
                                        } else {
                                          print('Could not launch $url');
                                        }
                                      }

                                      print(todo.url);
                                      launchURL(todo.url);
                                    },
                                  )
                                : Container(
                                    child: Text(""),
                                  ),
                            IconButton(
                              icon: Icon(Icons.date_range),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2030))
                                    .then((selectedDate) {
                                  setState(() {
                                    model.updateTodo(
                                      todo.copy(deadline: selectedDate),
                                    );
                                  });
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              onPressed: () => model.removeTodo(todo),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          todo.deadline == null
                              ? 'Deadline Not Set'
                              : 'by ' + todo.deadline.toString().split(" ")[0],
                        ),
                        title: Text(
                          todo.name,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color:
                                todo.isCompleted == 1 ? _color : Colors.black54,
                            decoration: todo.isCompleted == 1
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _todos.length + 1,
                ),
              ),
            ),
          ]),
        ),
      );
    });
  }
}

/*
Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                    child: Container(
                      color: Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TextDisplay(
                            //   firstText: "Username",
                            //   hintText: "Meow",
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Username:",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20.0),
                                ),
                                Text(
                                  "Meow",
                                  style: TextStyle(
                                      color: kPrimaryLightColor,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20.0),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Email:",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20.0),
                                ),
                                Text(
                                  "Meow@meow.com",
                                  style: TextStyle(
                                      color: kPrimaryLightColor,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20.0),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: kPrimaryLightColor,
                                  size: 20.0,
                                  semanticLabel:
                                      'Text to announce in accessibility modes',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Settings",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20.0),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: kPrimaryLightColor,
                                  size: 20.0,
                                  semanticLabel:
                                      'Text to announce in accessibility modes',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
*/

/*
Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [kPrimaryLightColor, kPrimaryColor])),
              child: Container(
                width: double.infinity,
                height: 350.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            // NetworkImage(
                            //   "https://www.trendrr.net/wp-content/uploads/2017/06/Deepika-Padukone-1.jpg",
                            // ),
                            AssetImage('assets/images/profile_placeholder.jpg'),
                        radius: 50.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Meow",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Dream BIG, Work HARD",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.white,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Completed",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "12",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Goals",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "5",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Within Deadline",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "4",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
*/
