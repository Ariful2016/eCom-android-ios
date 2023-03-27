import 'package:ecom_firebase/pages/home/home_page.dart';
import 'package:ecom_firebase/pages/notification/notification_page.dart';
import 'package:ecom_firebase/pages/profile/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../const/constants.dart';
import '../const/enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Shop Icon.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, HomePage.routeName),
              ),
              SpeedDial(
                icon: Icons.share,
                backgroundColor: Colors.grey,
                elevation: 0,
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.notifications),
                    label: 'Notification',
                    onTap: () {
                      Navigator.pushNamed(context, NotificationPage.routeName);
                    },
                    backgroundColor: Colors.amber,
                  ),
                  SpeedDialChild(
                      child: Icon(Icons.fireplace_outlined),
                      label: 'Fire',
                      onTap: () {},
                      backgroundColor: Colors.red),
                  SpeedDialChild(
                      child: Icon(Icons.home),
                      label: 'Home',
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, HomePage.routeName);
                      },
                      backgroundColor: Colors.green),
                ],
              ),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Chat bubble Icon.svg"),
                onPressed: () async{
                   // share test
                  const urlPreview = 'https://www.youtube.com/watch?v=CNUBhb_cM6E';
                  await Share.share('This is share text\n\n$urlPreview');
                },
              ),
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/User Icon.svg",
                    color: MenuState.profile == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, ProfilePage.routeName)),
            ],
          )),
    );
  }
}
