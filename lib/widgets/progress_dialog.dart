
import 'package:flutter/material.dart';

class CustomProgress {

  static showProgressDialog(BuildContext context, String title) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(left: 15),),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }
}
