import 'package:firebase_auth/firebase_auth.dart';
import 'package:gogogoals/model/user_model.dart';
import 'package:gogogoals/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create guser from Firebase User
  Guser _guserFromFirebaseUser(User user) {
    return user != null
        ? Guser(uid: user.uid, username: "USERNAME TO BE UPDATED")
        : null;
  }

  Stream<Guser> get user {
    return _auth.authStateChanges().map(_guserFromFirebaseUser);
  }

  //sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _guserFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _guserFromFirebaseUser(user);
    } catch (e) {
      if (e.code == 'email-already-in-use') {
        print('email already in use');
        return null;
      }
      print(e.toString());
      return null;
    }
  }

  //register
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      //create a doc for new user
      await DatabaseService().updateUserData(email, user.uid);

      return _guserFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
