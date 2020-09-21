import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gogogoals/components/loading.dart';

import 'package:gogogoals/components/rounded_button.dart';
import 'package:gogogoals/components/rounded_input.dart';
import 'package:gogogoals/components/rounded_passwordField.dart';
import 'package:gogogoals/components/formChange_line.dart';
import 'package:gogogoals/services/auth.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String username = '';
  String password = '';
  String confpassword = '';
  String error = '';

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  ]);

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
                          // color: Colors.grey[800],
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 50),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      "Sign up to continue!",
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 20),
                    ),
                    SizedBox(height: size.height * 0.03),
                    RoundedInputField(
                      hintText: "Email",
                      validator: EmailValidator(
                          errorText: 'Please enter valid email address'),
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    RoundedInputField(
                      hintText: "Username",
                      validator: RequiredValidator(
                          errorText: 'Please enter a username'),
                      onChanged: (val) {
                        setState(() => username = val);
                      },
                    ),
                    RoundedPasswordField(
                      hintText: "Password",
                      validator: passwordValidator,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    RoundedPasswordField(
                      hintText: "Confirm Password",
                      validator: (val) =>
                          MatchValidator(errorText: 'passwords do not match')
                              .validateMatch(val, password),
                      onChanged: (val) {
                        setState(() => confpassword = val);
                      },
                    ),
                    RoundedButton(
                      text: "SIGN UP",
                      press: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            print('exception');
                            setState(() {
                              setState(() => loading = false);
                              error = 'email is already registered';
                            });
                          }
                        } else {
                          setState(() => error = 'please check your inputs');
                        }
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    SizedBox(height: size.height * 0.03),
                    FormChange(
                      login: false,
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome",
              style: TextStyle(
                  // color: Colors.grey[800],
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Open Sans',
                  fontSize: 50),
            ),
            SizedBox(height: size.height * 0.03),
            Text(
              "Sign up to continue!",
              style: TextStyle(
                  color: Colors.grey[800],
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Open Sans',
                  fontSize: 20),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Email",
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Username",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              hintText: "Password",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              hintText: "Confirm Password",
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGN UP",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            // OrDivider(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     SocalIcon(
            //       iconSrc: "assets/icons/facebook.svg",
            //       press: () {},
            //     ),
            //     SocalIcon(
            //       iconSrc: "assets/icons/twitter.svg",
            //       press: () {},
            //     ),
            //     SocalIcon(
            //       iconSrc: "assets/icons/google-plus.svg",
            //       press: () {},
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
*/
