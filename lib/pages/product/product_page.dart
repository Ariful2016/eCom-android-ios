import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_firebase/models/ProductModel.dart';
import 'package:ecom_firebase/pages/home/home_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../const/constants.dart';
import '../../const/size_config.dart';
import '../../helper/check_internet.dart';
import '../../provider/product_provider.dart';
import '../../widgets/custom_surfix_icon.dart';
import '../../widgets/default_button.dart';
import '../../widgets/form_error.dart';
import '../../widgets/progress_dialog.dart';

class ProductPage extends StatefulWidget {
  static const String routeName = '/product_upload_page';

  @override
  State<ProductPage> createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _dateController = TextEditingController();

  ProductModel _productModel = ProductModel();

  bool remember = false;
  final List<String?> errors = [];

  ImageSource _imageSource = ImageSource.gallery;
  String? _imagePath;
  DateTime? _dateTime;

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

  String? _category;
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(20),
            horizontal: getProportionateScreenWidth(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: getProportionateScreenWidth(150),
              width: getProportionateScreenWidth(200),
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  border: Border.all(
                    color: kPrimaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imagePath == null ? null : Image.file(File(_imagePath!), fit: BoxFit.cover,),
             ),
            ),
            SizedBox(height: getProportionateScreenHeight(20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    _imageSource = ImageSource.camera;
                    _pickImage();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                      height: getProportionateScreenWidth(50),
                      width: getProportionateScreenWidth(50),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/camera.png'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _imageSource = ImageSource.gallery;
                    _pickImage();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                    child: Container(
                      height: getProportionateScreenWidth(50),
                      width: getProportionateScreenWidth(50),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/gallery.png'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(40),),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildNameFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  buildCategoryFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  buildDescriptionFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  buildPriceFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  buildDateFormField(),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FormError(errors: errors)),
                  SizedBox(height: getProportionateScreenHeight(40)),
                  DefaultButton(
                    text: "Upload Product",
                    press: () {
                      _uploadProduct();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
          addError(error: 'Enter product name');
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Product Name",
        hintText: "Enter product name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User Icon.svg"),
      ),
    );
  }
  DropdownButtonFormField buildCategoryFormField() {
    return DropdownButtonFormField<String>(
      hint: const Text('Select product category'),
      value: _category,
      onChanged: (value){
        setState(() {
          _category = value;
        });
       // _productModel.category = _category;
      },
      items: _productProvider.categoryList.map((cat) => DropdownMenuItem(
        child: Text(cat),
        value: cat,
      )).toList(),
      validator: (value){
        if(value == null){
          addError(error: 'Select product Category');
        }
        return null;
      },
      decoration:  const InputDecoration(
        labelText: "Product Category",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      controller: _descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: 'Enter product description');
          return "";
        }
        return null;
      },
      decoration:  const InputDecoration(
        labelText: "Product Description",
        hintText: "Enter product description",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User Icon.svg"),
      ),
    );
  }
  TextFormField buildDateFormField() {
    return TextFormField(

      decoration: InputDecoration(
        labelText: "Upload Time",
        hintText: _dateTime == null? 'Select upload time' : getFormattedDate(_dateTime!, 'dd/MM/yyyy'),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: (){
              _pickDate();
            },
              child: Icon(Icons.date_range_outlined)
          ),
        ),
      ),
    );
  }

  TextFormField buildPriceFormField() {
    return TextFormField(
      controller: _priceController,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: 'Enter product price');
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Product Price",
        hintText: "Enter product price",
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
  void _pickDate() async{
    final dt = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year-1),
        lastDate: DateTime.now()
    );

    if(dt != null){
      setState(() {
        _dateTime = dt;
        print(_dateTime);
      });
      _productModel.timestamp = Timestamp.fromDate(_dateTime!);
    }
  }
  void _uploadProduct() {

    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      _productModel.name = _nameController.text;
      _productModel.category = _category;
      _productModel.description = _descriptionController.text;
      _productModel.price = num.parse(_priceController.text);
      _productModel.isAvailable = true;

      if(_imagePath == null){
        showMessage(context, 'Choose product image');
      }

      if(_dateTime == null){
        showMessage(context, 'Select upload time');
      }
      CustomProgress.showProgressDialog(context, 'Please wait...');
      _uploadImageToStorage();

    }

  }



  void _uploadImageToStorage() async{

    final result = await isConnectedToInternet();
    final uploadFile= File(_imagePath!);
    final imageName = '$_category${DateTime.now()}';
    final imageRef = FirebaseStorage.instance.ref().child('Products_/$imageName');
    try{
      final uploadTask = imageRef.putFile(uploadFile);
      final snapshot = await uploadTask.whenComplete(() {

      });
      final dlUrl = await snapshot.ref.getDownloadURL();
      _productModel.imageUrl = dlUrl;
      print(dlUrl);
      if(result){
        _productProvider.addProduct(_productModel).then((_) =>
        Navigator.pushReplacementNamed(context, HomePage.routeName));
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
