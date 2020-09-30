import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gogogoals/model/todo_model.dart';
import 'package:gogogoals/model/task_model.dart';
import 'package:gogogoals/model/user_model.dart';

class DatabaseService {
  DatabaseService();

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('userData');

  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('taskData');

  final CollectionReference todoCollection =
      FirebaseFirestore.instance.collection('todoData');

  Future updateUserData(String uid, String username) async {
    return await userCollection.doc(uid).set({
      'username': username,
    });
  }

  Future getUserData(uid) async {
    userCollection.doc(uid).get().then((DocumentSnapshot documentSnapshot) =>
        {if (documentSnapshot.exists) {} else {}});
  }

  Future<List<Task>> getAllTasks(uid) async {
    List<Task> tasks = [];
    await taskCollection
        .where("owner", isEqualTo: uid)
        .get()
        .then((snapshot) => tasks =
            snapshot.docs.map((ss) => Task.fromJson(ss.data())).toList())
        .catchError((error) => print("Failed to load task: $error"));
    return tasks;
  }

  Future<List<Task>> getOngoingTasks(uid) async {
    List<Task> tasks = [];
    await taskCollection
        .where("owner", isEqualTo: uid)
        .where("status", isEqualTo: 0)
        .get()
        .then((snapshot) => tasks =
            snapshot.docs.map((ss) => Task.fromJson(ss.data())).toList())
        .catchError((error) => print("Failed to load task: $error"));
    return tasks;
  }

  Future<List<Task>> getCompletedTasks(uid) async {
    List<Task> tasks = [];
    await taskCollection
        .where("owner", isEqualTo: uid)
        .where("status", isEqualTo: 1)
        .get()
        .then((snapshot) {
      tasks = snapshot.docs.map((ss) => Task.fromJson(ss.data())).toList();
    }).catchError((error) => print("Failed to load task: $error"));
    return tasks;
  }

  Future<List<Todo>> getAllTodos(uid) async {
    List<Todo> todos = [];
    await todoCollection
        .where("owner", isEqualTo: uid)
        .get()
        .then((snapshot) => todos =
            snapshot.docs.map((ss) => Todo.fromJson(ss.data())).toList())
        .catchError((error) => print("Failed to load todo: $error"));
    return todos;
  }

  Future removeTask(Task task) async {
    return taskCollection
        .doc(task.id)
        .delete()
        .then((value) => print("Task removed"))
        .catchError((error) => print("Failed to remove task: $error"));
  }

  Future removeTodo(Todo todo) async {
    return taskCollection
        .doc(todo.id)
        .delete()
        .then((value) => print("Todo Removed"))
        .catchError((error) => print("Failed to remove todo: $error"));
  }

  Future updateTask(Task task, String uid) async {
    return taskCollection
        .doc(task.id)
        .update({
          'name': task.name,
          'owner': uid,
          'status': task.status,
          'color': task.color,
          'code_point': task.codePoint,
        })
        .then((value) => print("Task updated"))
        .catchError((error) => print("Failed to update task: $error"));
  }

  Future updateTodo(Todo todo, String uid) async {
    return todoCollection
        .doc(todo.id)
        .update({
          'name': todo.name,
          'completed': todo.isCompleted,
          'owner': uid,
          'parent': todo.parent,
        })
        .then((value) => print("Todo update"))
        .catchError((error) => print("Failed to update todo: $error"));
  }

  Future addTask(Task task, String uid) async {
    return taskCollection
        .doc(task.id)
        .set({
          'id': task.id,
          'name': task.name,
          'owner': uid,
          'status': task.status,
          'color': task.color,
          'code_point': task.codePoint,
        })
        .then((value) => print("Task Added"))
        .catchError((error) => print("Failed to add task: $error"));
  }

  Future addTodo(Todo todo, String uid) async {
    return todoCollection
        .doc(todo.id)
        .set({
          'id': todo.id,
          'name': todo.name,
          'completed': todo.isCompleted,
          'parent': todo.parent,
          'owner': uid,
        })
        .then((value) => print("Todo Added"))
        .catchError((error) => print("Failed to add todo: $error"));
  }
}
