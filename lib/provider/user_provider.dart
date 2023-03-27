

import 'package:ecom_firebase/db/firestore_helper.dart';
import 'package:ecom_firebase/models/user.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{

  Future<void> saveUserDataToDB(UserModel userModel) => FirestoreHelper.addUser(userModel);
  Future<void> saveProfileToDB(UserModel userModel) =>
      FirestoreHelper.updateProfilePic(userModel);

  Future<UserModel?> getCurrentUser() async{
    final snapshot = await FirestoreHelper.getCurrentUser();
    if(snapshot.docs.isNotEmpty){
      final userModel = UserModel.fromMap(snapshot.docs.first.data());
      return userModel;
    }
    return null;
  }
}