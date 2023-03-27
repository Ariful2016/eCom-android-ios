
import 'package:ecom_firebase/pages/signup/body.dart';
import 'package:flutter/material.dart';

import '../../const/size_config.dart';

class SignupPage extends StatefulWidget {

  static const String routeName = 'signup_page';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Body(),
          ],
        ),
      ),
    );
  }
}
