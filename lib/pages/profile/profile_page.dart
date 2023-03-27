import 'package:ecom_firebase/const/constants.dart';
import 'package:ecom_firebase/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../profile/components/body.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName ='/profile_page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Body(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:  SpeedDial(
        icon: Icons.share,
        backgroundColor: kPrimaryColor,
        children: [
          SpeedDialChild(
              child: Icon(Icons.notifications),
              label: 'Notification',
              onTap: (){},
            backgroundColor: Colors.amber,
          ),
          SpeedDialChild(
              child: Icon(Icons.fireplace_outlined),
              label: 'Fire',
              onTap: (){},
            backgroundColor: Colors.red
          ),
          SpeedDialChild(
              child: Icon(Icons.home),
              label: 'Home',
              onTap: (){
                Navigator.pushReplacementNamed(context, HomePage.routeName);
              },
            backgroundColor: Colors.green
          ),
        ],
      )

    );
  }
}

