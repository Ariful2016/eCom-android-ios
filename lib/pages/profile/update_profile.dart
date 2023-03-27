
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_firebase/const/size_config.dart';
import 'package:ecom_firebase/pages/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../const/constants.dart';
import '../../helper/check_internet.dart';
import '../../models/user.dart';
import '../../provider/user_provider.dart';
import '../../widgets/custom_surfix_icon.dart';
import '../../widgets/default_button.dart';
import '../../widgets/form_error.dart';
import '../../widgets/progress_dialog.dart';
import '../auth/firebase_auth_service.dart';

class UpdateProfilePage extends StatefulWidget {
  static const String routeName = '/update_profile';

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _designationController = TextEditingController();
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

  late UserProvider _userProvider;
  UserModel _userModel = UserModel();
  ImageSource _imageSource = ImageSource.gallery;
  String? _imagePath;
  bool isSaving = false;
  String _imageUrl = '';
  final userId = FirebaseAuthService.currentUser?.uid;
  @override
  void didChangeDependencies() async{
    _userProvider = Provider.of<UserProvider>(context);
    final model = await _userProvider.getCurrentUser();
    if(model != null){
      _userModel = model;
      _nameController.text = _userModel.name!;
      _emailController.text = _userModel.email!;
      if(_userModel.phone != null){
        _phoneController.text = _userModel.phone!;
      }
      if(_userModel.address != null){
        _addressController.text = _userModel.address!;
      }
      if(_userModel.designation != null){
        _designationController.text = _userModel.designation!;
      }

     if(_userModel.imageUrl != null){
       _imageUrl = _userModel.imageUrl!;
       print(_imageUrl);
     }
    }
    //print('did');
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _designationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update profile'),),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20),horizontal: getProportionateScreenWidth(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: getProportionateScreenWidth(115),
              width: getProportionateScreenWidth(115),
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                CircleAvatar(
                  child: FutureBuilder(
                  future: _userProvider.getCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.data?.imageUrl != null) {
                      return CircleAvatar(
                        radius: getProportionateScreenWidth(115),
                        backgroundImage: NetworkImage(snapshot.data!.imageUrl!),
                      );
                    }else {
                      return  CircleAvatar(
                          radius: getProportionateScreenWidth(115),
                          backgroundImage:
                          AssetImage("assets/images/Profile.jpg"));
                    }
                  },
                ),
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
            SizedBox(height: getProportionateScreenHeight(40),),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildNameFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  buildEmailFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  buildPhoneFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  buildDesignationFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  buildAddressFormField(),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FormError(errors: errors)
                  ),
                  SizedBox(height: getProportionateScreenHeight(40)),
                  DefaultButton(
                    text: "Update",
                    press: () {
                      _updateProfile();
                    },
                  ),
                ],
              ),
            ),


          ],
        ),
      )
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
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
  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
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
  TextFormField buildPhoneFormField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
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
        labelText: "Phone",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Call.svg"),
      ),
    );
  }
  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: _addressController,
      keyboardType: TextInputType.text,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
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
        labelText: "Address",
        hintText: "Enter your address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }
  TextFormField buildDesignationFormField() {
    return TextFormField(
      controller: _designationController,
      keyboardType: TextInputType.text,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
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
        labelText: "Designation",
        hintText: "Enter your designation",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User Icon.svg"),
      ),
    );
  }

  void _pickImage() async{
    final pickedFile = await ImagePicker().pickImage(source: _imageSource, imageQuality: 60);
    if(pickedFile != null){
      setState(() {
        _imagePath = pickedFile.path ;
        print(_imagePath);
      });
    }
  }

   _updateProfile() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        _userModel.name = _nameController.text;
        _userModel.email = _emailController.text;
        _userModel.phone = _phoneController.text;
        _userModel.address = _addressController.text;
        _userModel.designation = _designationController.text;
        _userModel.id = userId;
        _userModel.createdAt = Timestamp.fromMicrosecondsSinceEpoch(DateTime.now().millisecond);
        if(_imagePath == null){
          showMessage(context, 'Select an Image');
        }

        print(_userModel.name);
        print(_imagePath);
        CustomProgress.showProgressDialog(context, 'Please wait...');
        _uploadImageToStorage();

      }

  }

  void _uploadImageToStorage() async{
    final result = await isConnectedToInternet();
    final uploadFile= File(_imagePath!);
    final imageName = 'Product_${DateTime.now()}';
    final imageRef = FirebaseStorage.instance.ref().child('Profile_/$imageName');
    try{
      final uploadTask = imageRef.putFile(uploadFile);
      final snapshot = await uploadTask.whenComplete(() {

      });
      final dlUrl = await snapshot.ref.getDownloadURL();
      _userModel.imageUrl = dlUrl;
      print(dlUrl);
      if(result){
        print(_userModel.id);
        if(_userModel.id != null){
          print(_userModel.id);
          _userProvider.saveProfileToDB(_userModel).then((_) =>
              Navigator.pushReplacementNamed(context, ProfilePage.routeName));
        }else{
          Navigator.pop(context);
          showMessage(context, 'Failed to upload your profile');
        }

      }else{
        Navigator.pop(context);
        showMessage(context, 'No internet connection detected');
      }

    }catch(e){
      Navigator.pop(context);
      showMessage(context, 'Failed to upload your profile');
      throw e;
    }
  }


}
