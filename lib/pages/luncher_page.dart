
import 'package:ecom_firebase/pages/auth/firebase_auth_service.dart';
import 'package:ecom_firebase/pages/home/home_page.dart';
import 'package:ecom_firebase/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';


class LauncherPage extends StatefulWidget {
  static const String routeName = 'launcher_page';

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      if(FirebaseAuthService.currentUser == null){
        Navigator.pushReplacementNamed(context, SplashScreen.routeName);
      }else{
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
