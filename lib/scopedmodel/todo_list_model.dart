// import 'dart:convert';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gogogoals/model/category_model.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:sqflite/sqflite.dart';

// import 'package:objectdb/objectdb.dart';

import 'package:gogogoals/model/todo_model.dart';
import 'package:gogogoals/model/task_model.dart';
//import 'package:gogogoals/services/db_provider.dart';
import 'package:gogogoals/services/database.dart';

class TodoListModel extends Model {
  // ObjectDB db;
  //var _db = DBProvider.db;
  var _db2 = DatabaseService();
  final String uid;

  bool _isLoading = false;
  List<Category> _categories = [];
  List<Task> _tasks = [];
  List<Task> _vtasks = [];
  List<Todo> _todos = [];
  Map<String, int> _taskCompletionPercentage = Map();

  TodoListModel({@required this.uid});
  List<Category> get categories => _categories.toList();
  List<Todo> get todos => _todos.toList();
  List<Task> get vtasks => _vtasks.toList();
  List<Task> get tasks => _tasks.toList();
  bool get isLoading => _isLoading;
  static TodoListModel of(BuildContext context) =>
      ScopedModel.of<TodoListModel>(context);

  int getTaskCompletionPercent(Task task) {
    return _taskCompletionPercentage[task.id];
  }

  int getTotalTodosFrom(Task task) {
    return todos.where((it) => it.parent == task.id).length;
  }

  DateTime getClosestDeadline(Task task) {
    List<Todo> copyTodos = todos
        .where((it) => it.parent == task.id)
        .where((it) => it.isCompleted == 0)
        .where((it) => it.deadline != null)
        .toList();
    copyTodos.sort((a, b) => a.deadline.compareTo(b.deadline));

    if (copyTodos.length == 0)
      return null;
    else
      return copyTodos[0].deadline;
  }

  @override
  void addListener(listener) {
    super.addListener(listener);
    // update data for every subscriber, especially for the first one
    _isLoading = true;
    loadTodos();
    notifyListeners();
  }

  @override
  void removeListener(listener) {
    super.removeListener(listener);
    print("remove listner called");
    // DBProvider.db.closeDB();
  }

  void loadTodos() async {
    _tasks = await _db2.getAllTasks(uid);
    _todos = await _db2.getAllTodos(uid);

    _tasks.forEach((it) => _calcTaskCompletionPercent(it.id));
    _vtasks = _tasks;
    _isLoading = false;
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
  }

  void loadVisibleTasks(int status) async {
    if (status == 2) {
      _vtasks = _tasks.toList();
    } else
      _vtasks = _tasks.where((it) => it.status == status).toList();
    print(_vtasks);

    _isLoading = false;
    notifyListeners();
  }

  void addCategory(Category cat) {
    _categories.add(cat);
    _db2.addCategory(cat, uid);
  }

  void removeCategory(Category cat) {
    // delete
    for (var task in _tasks.where((it) => it.parent == cat.id)) {
      removeTask(task);
    }

    _db2.removeCategory(cat).then((_) {
      _categories.removeWhere((it) => it.id == cat.id);
      //  _tasks.removeWhere((it) => it.parent == cat.id);
      notifyListeners();
    });
  }

  void updateCategory(Category cat) {
    var oldTask = _tasks.firstWhere((it) => it.id == cat.id);
    var replaceIndex = _tasks.indexOf(oldTask);
    _categories.replaceRange(replaceIndex, replaceIndex + 1, [cat]);
    //_db.updateTask(task);
    _db2.updateCategory(cat, uid);
  }

  void addTask(Task task) {
    _tasks.add(task);
    _calcTaskCompletionPercent(task.id);
    //_db.insertTask(task);
    _db2.addTask(task, uid);
    notifyListeners();
  }

  void removeTask(Task task) {
    //_db.removeTask(task);
    for (var todo in _todos.where((it) => it.parent == task.id)) {
      removeTodo(todo);
    }

    _db2.removeTask(task).then((_) {
      _tasks.removeWhere((it) => it.id == task.id);
      //  _todos.removeWhere((it) => it.parent == task.id);
      notifyListeners();
    });
  }

  void updateTask(Task task) {
    var oldTask = _tasks.firstWhere((it) => it.id == task.id);
    var replaceIndex = _tasks.indexOf(oldTask);
    _tasks.replaceRange(replaceIndex, replaceIndex + 1, [task]);
    if (getTaskCompletionPercent(task) == 100) {
      task.status = 1;
    } else {
      task.status = 0;
    }
    //_db.updateTask(task);
    _db2.updateTask(task, uid);
    notifyListeners();
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    _syncJob(todo);
    //_db.insertTodo(todo);
    _db2.addTodo(todo, uid);
    notifyListeners();
  }

  void removeTodo(Todo todo) {
    _todos.removeWhere((it) => it.id == todo.id);
    //_db.removeTodo(todo);
    _db2.removeTodo(todo);
    _syncJob(todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) {
    for (Task t in _tasks) {
      print(t.id);
    }
    print(todo.parent);
    var oldTodo = _todos.firstWhere((it) => it.id == todo.id);
    var replaceIndex = _todos.indexOf(oldTodo);
    _todos.replaceRange(replaceIndex, replaceIndex + 1, [todo]);
    _syncJob(todo);
    updateTask(_tasks.firstWhere((task) => task.id == todo.parent));
    //_db.updateTodo(todo);
    _db2.updateTodo(todo, uid);
    notifyListeners();
  }

  _syncJob(Todo todo) {
    _calcTaskCompletionPercent(todo.parent);
    // _syncTodoToDB();
  }

  void _calcTaskCompletionPercent(String taskId) {
    var todos = this.todos.where((it) => it.parent == taskId);
    var totalTodos = todos.length;

    if (totalTodos == 0) {
      _taskCompletionPercentage[taskId] = 0;
    } else {
      var totalCompletedTodos = todos.where((it) => it.isCompleted == 1).length;
      _taskCompletionPercentage[taskId] =
          (totalCompletedTodos / totalTodos * 100).toInt();
    }
    // return todos.fold(0, (total, t odo) => t odo.isCompleted ? total + scoreOfTask : total);
  }

  // Future<int> _syncTodoToDB() async {
  //   return await db.update({'user': 'guest'}, {'todos': _todos});
  // }
}
