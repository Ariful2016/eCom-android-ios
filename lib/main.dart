import 'package:ecom_firebase/pages/auth/firebase_auth_service.dart';
import 'package:ecom_firebase/pages/card/card_page.dart';
import 'package:ecom_firebase/pages/details/details_page.dart';
import 'package:ecom_firebase/pages/forget_password/forget_password.dart';
import 'package:ecom_firebase/pages/home/home_page.dart';
import 'package:ecom_firebase/pages/luncher_page.dart';
import 'package:ecom_firebase/pages/notification/notification_page.dart';
import 'package:ecom_firebase/pages/product/product_page.dart';
import 'package:ecom_firebase/pages/profile/profile_page.dart';
import 'package:ecom_firebase/pages/profile/update_profile.dart';
import 'package:ecom_firebase/pages/signin/signin_page.dart';
import 'package:ecom_firebase/pages/signup/signup_page.dart';
import 'package:ecom_firebase/pages/splash/splash_page.dart';
import 'package:ecom_firebase/pages/theme.dart';
import 'package:ecom_firebase/provider/product_provider.dart';
import 'package:ecom_firebase/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  initScreen = await sharedPreferences.getInt('initScreen');
  await sharedPreferences.setInt('initScreen', 1);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> UserProvider()),
        ChangeNotifierProvider(create: (context)=> ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        initialRoute: initScreen == 0 || initScreen == null ? LauncherPage.routeName :
        (FirebaseAuthService.currentUser != null ? HomePage.routeName : SigninPage.routeName),
        routes: {
          LauncherPage.routeName: (context) => LauncherPage(),
          HomePage.routeName: (context) => HomePage(),
          SplashScreen.routeName: (context) => SplashScreen(),
          SigninPage.routeName: (context) => SigninPage(),
          SignupPage.routeName: (context) => SignupPage(),
          ForgetPassword.routeName: (context) => ForgetPassword(),
          CardPage.routeName: (context) => CardPage(),
          DetailsPage.routeName: (context) => DetailsPage(),
          ProfilePage.routeName: (context) => ProfilePage(),
          UpdateProfilePage.routeName: (context) => UpdateProfilePage(),
          ProductPage.routeName: (context) => ProductPage(),
          NotificationPage.routeName: (context) => NotificationPage(),
        },
      ),
    );
  }
}
