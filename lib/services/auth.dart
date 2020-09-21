import 'package:firebase_auth/firebase_auth.dart';
import 'package:gogogoals/model/userModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Guser _guserFromFirebaseUser(User user) {
    return user != null ? Guser(uid: user.uid) : null;
  }

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
  
  //register

  //sign out
}
