import 'package:ecom_firebase/pages/auth/firebase_auth_service.dart';
import 'package:ecom_firebase/pages/product/product_page.dart';
import 'package:ecom_firebase/pages/profile/update_profile.dart';
import 'package:ecom_firebase/pages/signin/signin_page.dart';
import 'package:flutter/material.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              Navigator.pushNamed(context, UpdateProfilePage.routeName)
            },
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Upload Product",
            icon: "assets/icons/Plus Icon.svg",
            press: () {
              Navigator.pushNamed(context, ProductPage.routeName);
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              FirebaseAuthService.logoutUser();
              Navigator.pushReplacementNamed(context, SigninPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
