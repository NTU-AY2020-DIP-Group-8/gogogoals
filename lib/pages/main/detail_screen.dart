import 'package:flutter/material.dart';
import 'package:gogogoals/components/task_progress_indicator.dart';
import 'package:gogogoals/components/todo_badge.dart';
import 'package:gogogoals/model/hero_id_model.dart';
import 'package:gogogoals/model/task_model.dart';
import 'package:gogogoals/scopedmodel/todo_list_model.dart';
import 'package:gogogoals/utils/color_utils.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_todo_screen.dart';
import 'edit_task_screen.dart';

class DetailScreen extends StatefulWidget {
  final String taskId;
  final HeroId heroIds;

  DetailScreen({
    @required this.taskId,
    @required this.heroIds,
  });

  @override
  State<StatefulWidget> createState() {
    return _DetailScreenState();
  }
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset(0, 1.0), end: Offset(0.0, 0.0))
        .animate(_controller);
  }

  // getContainer(bool isCompleted, {Widget child}) {
  //   if (isCompleted) {
  //     return Container(
  //       padding: EdgeInsets.only(left: 22.0, right: 22.0),
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.centerLeft,
  //           end: Alignment.centerRight,
  //           stops: [0.4, 0.6, 1],
  //           colors: <Color>[
  //             Colors.grey.shade100,
  //             Colors.grey.shade50,
  //             Colors.white,
  //           ],
  //         ),
  //       ),
  //       child: child,
  //     );
  //   } else {
  //     return Container(
  //       padding: EdgeInsets.only(left: 22.0, right: 22.0),
  //       child: child,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return ScopedModelDescendant<TodoListModel>(
      builder: (BuildContext context, Widget child, TodoListModel model) {
        Task _task;

        try {
          _task = model.tasks.firstWhere((it) => it.id == widget.taskId);
        } catch (e) {
          return Container(
            color: Colors.white,
          );
        }

        var _todos =
            model.todos.where((it) => it.parent == widget.taskId).toList();
        _todos.sort((a, b) {
          if (a.deadline == null && b.deadline == null)
            return 0;
          else if (b.deadline == null)
            return -1;
          else if (a.deadline == null) return 1;
          return a.deadline.compareTo(b.deadline);
        });

        var _hero = widget.heroIds;
        var _color = ColorUtils.getColorFrom(id: _task.color);
        var _icon = IconData(_task.codePoint, fontFamily: 'MaterialIcons');

        return Theme(
          data: ThemeData(primarySwatch: _color),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black26),
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: Icon(Icons.edit),
                  color: _color,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskScreen(
                          taskId: _task.id,
                          taskName: _task.name,
                          icon: _icon,
                          color: _color,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  color: _color,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SimpleAlertDialog(
                  prevContext: context,
                  color: _color,
                  onActionPressed: () {
                    model.removeTask(_task);
                  },
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
              child: Column(children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 36.0, vertical: 0.0),
                  height: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TodoBadge(
                        color: _color,
                        codePoint: _task.codePoint,
                        id: _hero.codePointId,
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 4.0),
                        child: Hero(
                          tag: _hero.remainingTaskId,
                          child: Text(
                            "${model.getTotalTodosFrom(_task)} Task(s)",
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: Colors.grey[500]),
                          ),
                        ),
                      ),
                      Container(
                        child: Hero(
                          tag: 'title_hero_unused', //_hero.titleId,
                          child: Text(_task.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(color: Colors.black54)),
                        ),
                      ),
                      Spacer(),
                      Hero(
                        tag: _hero.progressId,
                        child: TaskProgressIndicator(
                          color: _color,
                          progress: model.getTaskCompletionPercent(_task),
                        ),
                      )
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
                              model.updateTask(_task);
                            },
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 8.0),
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
                                  : 'by ' +
                                      todo.deadline.toString().split(" ")[0],
                            ),
                            title: Text(
                              todo.name,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: todo.isCompleted == 1
                                    ? _color
                                    : Colors.black54,
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
            floatingActionButton: FloatingActionButton(
              heroTag: 'fab_new_task',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTodoScreen(
                        taskId: widget.taskId, heroIds: _hero, task: _task),
                  ),
                );
              },
              tooltip: 'New Todo',
              backgroundColor: _color,
              foregroundColor: Colors.white,
              child: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

typedef void Callback();

class SimpleAlertDialog extends StatelessWidget {
  final Color color;
  final Callback onActionPressed;
  final BuildContext prevContext;

  SimpleAlertDialog({
    @required this.prevContext,
    @required this.color,
    @required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color,
      icon: Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete this card?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'This is a one way street! Deleting this will remove all the task assigned in this card.'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () {
                    onActionPressed();
                    Navigator.of(context).pop();
                    Navigator.of(prevContext).pop();
                  },
                ),
                FlatButton(
                  child: Text('Cancel'),
                  textColor: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
