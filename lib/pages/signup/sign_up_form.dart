import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_firebase/models/user.dart';
import 'package:ecom_firebase/pages/auth/firebase_auth_service.dart';
import 'package:ecom_firebase/pages/home/home_page.dart';
import 'package:ecom_firebase/provider/user_provider.dart';
import 'package:ecom_firebase/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../const/constants.dart';
import '../../const/size_config.dart';
import '../../helper/check_internet.dart';
import '../../widgets/custom_surfix_icon.dart';
import '../../widgets/default_button.dart';
import '../../widgets/form_error.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late UserProvider _userProvider;

  Timestamp? _createTime = Timestamp.fromMicrosecondsSinceEpoch(DateTime.now().millisecond);
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;
  String? _conform_password;
  bool remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: FormError(errors: errors)
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () {
              _registerUser();
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => _conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && _password == _conform_password) {
          removeError(error: kMatchPassError);
        }
        _conform_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((_password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => _password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        _password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => _email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => _name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User Icon.svg"),
      ),
    );
  }

  void _registerUser() async{
    final result = await isConnectedToInternet();
    if(result){
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        CustomProgress.showProgressDialog(context, 'Please wait...');
        UserModel _userModel = UserModel(name: _name,email: _email, createdAt: _createTime);
        try{
          final user = await FirebaseAuthService.registerUser(_email!, _password!);
          if(user != null){
            _userProvider.saveUserDataToDB(_userModel).then((_) => Navigator.pushReplacementNamed(context, HomePage.routeName));

          }

        }on FirebaseAuthException catch (e){
          setState(() {
            errors.add(e.toString());
            Navigator.pop(context);
          });
        }
        // if all are valid then go to success screen

      }
    }else{
      showMessage(context, 'No internet connection detected');
    }

  }
}
