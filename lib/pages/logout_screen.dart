import 'package:flutter/material.dart';
import 'package:gogogoals/components/textDisplay.dart';
import 'package:gogogoals/constants.dart';

class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [kPrimaryLightColor, kPrimaryColor])),
              child: Container(
                width: double.infinity,
                height: .0,
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
                        radius: 150.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Logged Out Successfully!",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
