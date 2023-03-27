
import 'package:ecom_firebase/pages/signin/body.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const/size_config.dart';

class SigninPage extends StatefulWidget {
  static const routeName = '/signin_page';
  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: Body()
    );
  }

}
