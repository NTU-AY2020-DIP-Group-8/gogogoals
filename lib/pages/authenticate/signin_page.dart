import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:gogogoals/components/rounded_button.dart';
import 'package:gogogoals/components/rounded_input.dart';
import 'package:gogogoals/components/rounded_passwordField.dart';
import 'package:gogogoals/components/formChange_line.dart';
import 'package:gogogoals/components/loading.dart';
import 'package:gogogoals/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Welcome",
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 50),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      "Sign in to continue!",
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 20),
                    ),
                    SizedBox(height: size.height * 0.1),
                    RoundedInputField(
                      hintText: "Email/Username",
                      validator: EmailValidator(
                          errorText: 'Please enter valid email address'),
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    RoundedPasswordField(
                      hintText: "Password",
                      validator:
                          RequiredValidator(errorText: 'password is required'),
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    RoundedButton(
                      text: "Log In",
                      press: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Please check your inputs';
                              setState(() => loading = false);
                              print(loading);
                            });
                          }
                        } else {
                          setState(() => error = 'Please check your inputs');
                        }
                      },
                    ),
                    RoundedButton(
                      text: "Log In DEBUG",
                      press: () async {
                        dynamic result = await _auth.signInAnon();
                        if (result == null) {
                          print('error signing in');
                        } else {
                          print('signed in');
                          print(result.uid);
                        }
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    FormChange(
                      press: () {
                        widget.toggleView();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
/*
class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {}
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
*/
