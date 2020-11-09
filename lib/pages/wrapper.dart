import 'package:flutter/material.dart';
import 'package:gogogoals/model/user_model.dart';
import 'package:gogogoals/pages/authenticate/authenticate.dart';
import 'package:gogogoals/pages/main/home_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Guser>(context);

    //return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
