import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input.dart';
import '../components/rounded_passwordField.dart';
import 'login_page.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

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
              "Welcome",style: TextStyle(
  // color: Colors.grey[800],
  fontWeight: FontWeight.w900,
  fontStyle: FontStyle.normal,
  fontFamily: 'Open Sans',
  fontSize: 50),
            ),
            SizedBox(height: size.height * 0.03),
            Text(
              "Sign up to continue!",style: TextStyle(
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
