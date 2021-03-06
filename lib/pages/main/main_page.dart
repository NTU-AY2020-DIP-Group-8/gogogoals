import 'package:flutter/material.dart';
import 'package:gogogoals/route/scale_route.dart';
import 'package:provider/provider.dart';
import '../../components/task_progress_indicator.dart';
import '../../components/todo_badge.dart';
import '../../model/hero_id_model.dart';
import '../../model/task_model.dart';
import 'package:gogogoals/model/user_model.dart';
import '../../scopedmodel/todo_list_model.dart';
import '../../utils/color_utils.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../components/gradient_background.dart';
import 'add_task_screen.dart';
import 'detail_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Guser>(context);
    return ScopedModel<TodoListModel>(
      model: user.model,
      child: MaterialApp(
        title: 'Gogogoals',
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: ''),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  HeroId _generateHeroIds(Task task) {
    return HeroId(
      codePointId: 'code_point_id_${task.id}',
      progressId: 'progress_id_${task.id}',
      titleId: 'title_id_${task.id}',
      remainingTaskId: 'remaining_task_id_${task.id}',
    );
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  PageController _pageController;
  int _currentPageIndex = 0;
  int _pressAttention = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
        builder: (BuildContext context, Widget child, TodoListModel model) {
      var _isLoading = model.isLoading;

      var _tasks = model.vtasks;
      var _todos = model.todos;

      _tasks.sort((a, b) {
        DateTime dla = model.getClosestDeadline(a);
        DateTime dlb = model.getClosestDeadline(b);
        if (dla == null && dlb == null)
          return 0;
        else if (dlb == null)
          return -1;
        else if (dla == null) return 1;
        return dla.compareTo(dlb);
      });
      if (!_tasks.isEmpty || _currentPageIndex >= _tasks.length) {
        _currentPageIndex = _tasks.length - 1;
      }
      var backgroundColor = _tasks.isEmpty || _tasks.length == _currentPageIndex
          ? Colors.orange
          : ColorUtils.getColorFrom(id: _tasks[_currentPageIndex].color);
      if (!_isLoading) {
        // move the animation value towards upperbound only when loading is complete
        _controller.forward();
      }
      return GradientBackground(
        color: backgroundColor,
        // color: null,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            toolbarHeight: 15,
            // actions: [
            //   PopupMenuButton<Choice>(
            //     onSelected: (choice) {
            //       // Navigator.of(context).push(MaterialPageRoute(
            //       //     builder: (BuildContext context) =>
            //       //         PrivacyPolicyScreen()));
            //     },
            //     itemBuilder: (BuildContext context) {
            //       return choices.map((Choice choice) {
            //         return PopupMenuItem<Choice>(
            //           value: choice,
            //           child: Text(choice.title),
            //         );
            //       }).toList();
            //     },
            //   ),
            // ],
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : FadeTransition(
                  opacity: _animation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 0.0, left: 52.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(height: 16.0),
                            Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: Text("Hello Meow!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 32)),
                            ),
                            // ShadowImage(),
                            // Container(
                            //   // margin: EdgeInsets.only(top: 22.0),
                            //   child: Text(
                            //     '${widget.currentDay(context)}',
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .headline
                            //         .copyWith(color: Colors.white),
                            //   ),
                            // ),
                            // Text(
                            //   '${DateTimeUtils.currentDate} ${DateTimeUtils.currentMonth}',
                            //   style: Theme.of(context).textTheme.title.copyWith(
                            //       color: Colors.white.withOpacity(0.7)),
                            // ),
                            Container(height: 16.0),
                            (_todos
                                        .where((todo) => todo.isCompleted == 0)
                                        .length ==
                                    0)
                                ? Text(
                                    'All tasks have been completed!',
                                    style: TextStyle(fontSize: 20),
                                  )
                                : Text(
                                    'Hurry up! ${_todos.where((todo) => todo.isCompleted == 0).length} task(s) to complete!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    //  Theme.of(context).textTheme.body1.copyWith(
                                    //     color: Colors.white.withOpacity(0.7)),

                                    // )
                                  ),
                            Container(
                              height: 10.0,
                            ),
                            Row(children: [
                              Container(
                                // child: currentgoalCard(
                                //   color: Colors.orange,
                                // ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: (_pressAttention == 0)
                                            ? Colors.redAccent
                                            : Colors.transparent,
                                        spreadRadius: 3),
                                  ],
                                ),
                                height: 90,
                                width: 90,
                                margin: EdgeInsets.only(
                                    top: 16.0, bottom: 16.0, right: 10.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.flag,
                                    color: Colors.red,
                                    size: 50.0,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      //model.loadTodos();
                                      model.loadVisibleTasks(0);
                                      _pressAttention = 0;
                                      print("refresh");
                                      // _volume += 10;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                // child: currentgoalCard(
                                //   color: Colors.orange,
                                // ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: (_pressAttention == 1)
                                            ? Colors.blueAccent
                                            : Colors.transparent,
                                        spreadRadius: 3),
                                  ],
                                ),
                                height: 90,
                                width: 90,
                                margin: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 10.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.view_list,
                                    color: Colors.blue,
                                    size: 50.0,
                                  ),
                                  tooltip: 'All',
                                  onPressed: () {
                                    setState(() {
                                      //model.loadTodos();
                                      model.loadVisibleTasks(2);
                                      _pressAttention = 1;
                                      print("refresh");
                                      // _volume += 10;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                // child: currentgoalCard(
                                //   color: Colors.orange,
                                // ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: (_pressAttention == 2)
                                            ? Colors.greenAccent
                                            : Colors.transparent,
                                        spreadRadius: 3),
                                  ],
                                ),
                                height: 90,
                                width: 90,
                                margin: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 10.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.offline_pin,
                                    color: Colors.green,
                                    size: 50.0,
                                  ),
                                  tooltip: 'Completed',
                                  onPressed: () {
                                    setState(() {
                                      //model.loadTodos();
                                      model.loadVisibleTasks(1);
                                      _pressAttention = 2;
                                      print("refresh");
                                      // _volume += 10;
                                    });
                                  },
                                ),
                              ),
                              /*
                              Container(
                                child: AddPageCard(
                                  color: Colors.orange,
                                ),
                              ),*/
                            ])
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 32.0),
                        height: 350,
                        //fit: FlexFit.loose,
                        key: _backdropKey,
                        //flex: 1,
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification) {
                              print(
                                  "ScrollNotification = ${_pageController.page}");
                              var currentPage =
                                  _pageController.page.round().toInt();
                              if (_currentPageIndex != currentPage) {
                                setState(() => _currentPageIndex = currentPage);
                              }
                            }
                          },
                          child: PageView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == _tasks.length) {
                                // return AddPageCard(
                                //   color: Colors.orange,
                                // );
                              } else {
                                return TaskCard(
                                  backdropKey: _backdropKey,
                                  color: ColorUtils.getColorFrom(
                                      id: _tasks[index].color),
                                  getHeroIds: widget._generateHeroIds,
                                  getTaskCompletionPercent:
                                      model.getTaskCompletionPercent,
                                  getTotalTodos: model.getTotalTodosFrom,
                                  getClosestDeadline: model.getClosestDeadline,
                                  task: _tasks[index],
                                );
                              }
                            },
                            itemCount: _tasks.length + 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// class AddPageCard extends StatelessWidget {
//   final Color color;
//
//   const AddPageCard({Key key, this.color = Colors.black}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       elevation: 4.0,
//       margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
//       child: Material(
//         borderRadius: BorderRadius.circular(16.0),
//         color: Colors.white,
//         child: InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) {
//                   return AddTaskScreen();
//                 },
//               ),
//             );
//           },
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.add,
//                   size: 40.0,
//                   color: color,
//                 ),
//                 Container(
//                   height: 5.0,
//                 ),
//                 Text(
//                   'Add New Goal',
//                   style: TextStyle(color: color, fontSize: 11.5),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

typedef TaskGetter<T, V> = V Function(T value);

class TaskCard extends StatelessWidget {
  final GlobalKey backdropKey;
  final Task task;
  final Color color;

  final TaskGetter<Task, int> getTotalTodos;
  final TaskGetter<Task, HeroId> getHeroIds;
  final TaskGetter<Task, int> getTaskCompletionPercent;
  final TaskGetter<Task, DateTime> getClosestDeadline;

  TaskCard({
    @required this.backdropKey,
    @required this.color,
    @required this.task,
    @required this.getTotalTodos,
    @required this.getClosestDeadline,
    @required this.getHeroIds,
    @required this.getTaskCompletionPercent,
  });

  @override
  Widget build(BuildContext context) {
    var heroIds = getHeroIds(task);
    return GestureDetector(
      onTap: () {
        final RenderBox renderBox =
            backdropKey.currentContext.findRenderObject();
        var backDropHeight = renderBox.size.height;
        var bottomOffset = 60.0;
        var horizontalOffset = 52.0;
        var topOffset = MediaQuery.of(context).size.height - backDropHeight;
        var rect = RelativeRect.fromLTRB(
            horizontalOffset, topOffset, horizontalOffset, bottomOffset);
        Navigator.push(
          context,
          ScaleRoute(
            rect: rect,
            widget: DetailScreen(
              taskId: task.id,
              heroIds: heroIds,
            ),
          ),
          // MaterialPageRoute(
          //   builder: (context) => DetailScreen(
          //         taskId: task.id,
          //         heroIds: heroIds,
          //       ),
          // ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                  // mainAxisAlignment: ,
                  children: [
                    TodoBadge(
                      id: heroIds.codePointId,
                      codePoint: task.codePoint,
                      color: ColorUtils.getColorFrom(
                        id: task.color,
                      ),
                    ),
                    // Spacer(
                    //   flex: 8,
                    // ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Hero(
                        tag: heroIds.titleId,
                        child: (task.name.length < 12)
                            ? Text(task.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(
                                        color: Colors.black54, fontSize: 24.0))
                            : Text(task.name.substring(0, 11) + '...',
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(
                                        color: Colors.black54, fontSize: 24.0)),
                      ),
                    ),
                  ]),
              Container(
                margin: EdgeInsets.only(bottom: 4.0),
                child: Hero(
                    tag: heroIds.remainingTaskId,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "${getTotalTodos(task)} Task(s)",
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: Colors.grey[600], fontSize: 18.0),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                          ),
                          Text(
                            getClosestDeadline(task) == null
                                ? ''
                                : 'Closest Deadline: ' +
                                    getClosestDeadline(task)
                                        .toString()
                                        .split(" ")[0],
                            // "${getTotalTodos(task)} Task(s)",
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: Colors.grey[600]),
                          ),
                        ])),
              ),
              Spacer(),
              Hero(
                tag: heroIds.progressId,
                child: TaskProgressIndicator(
                  color: color,
                  progress: getTaskCompletionPercent(task),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
