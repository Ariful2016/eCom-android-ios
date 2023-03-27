import 'dart:io';

import 'package:ecom_firebase/models/user.dart';
import 'package:ecom_firebase/pages/auth/firebase_auth_service.dart';
import 'package:ecom_firebase/provider/user_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../helper/check_internet.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  late UserProvider _userProvider;
  UserModel _userModel = UserModel();
  ImageSource _imageSource = ImageSource.gallery;
  String? _imagePath;
  bool isSaving = false;
  final userId = FirebaseAuthService.currentUser?.uid;

  @override
  void didChangeDependencies() async{
    _userProvider = Provider.of<UserProvider>(context);
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if(isSaving) const Center(child: CircularProgressIndicator(),),
        SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/Profile.jpg"),
            ),
            Positioned(
              right: -16,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.white),
                    ),
                    primary: Colors.white,
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: () {
                    _imageSource = ImageSource.gallery;
                    _pickImage();
                  },
                  child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                ),
              ),
            )
          ],
        ),
      ),
      ]
    );
  }

  void _pickImage() async{
    final pickedFile = await ImagePicker().pickImage(source: _imageSource, imageQuality: 60);
    if(pickedFile != null){
      setState(() {
        _imagePath = pickedFile.path ;
      });
      final result = await isConnectedToInternet();
      if(result){
        if(_imagePath == null){
          isSaving = true;
          _uploadImageToStorage();
        }else{
          showMessage(context, 'Something wrong!');
        }
      }else{
        showMessage(context, 'No internet connection detected');
      }

    }
  }

  void _uploadImageToStorage() async{
    final uploadFile= File(_imagePath!);
    final imageName = 'ProfilePic_${DateTime.now()}';
    final imageRef = FirebaseStorage.instance.ref().child('User/$imageName');
    try{
      final uploadTask = imageRef.putFile(uploadFile);
      final snapshot = await uploadTask.whenComplete(() {

      });
      final dlUrl = await snapshot.ref.getDownloadURL();
      _userModel.imageUrl = dlUrl;
      print(dlUrl);
      _userProvider.saveProfileToDB(_userModel);
      //_productProvider.insertNewProduct(_productModel).then((_) => Navigator.pushReplacementNamed(context, DashBoardPage.routeName));
    }catch(e){
      setState(() {
        isSaving = false;
      });
      showMessage(context, 'Failed to upload profile image');
      print(e);
      throw e;
    }
  }
}

