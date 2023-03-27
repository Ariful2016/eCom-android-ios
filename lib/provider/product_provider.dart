
import 'package:ecom_firebase/db/firestore_helper.dart';
import 'package:ecom_firebase/models/ProductModel.dart';
import 'package:flutter/foundation.dart';

class ProductProvider extends ChangeNotifier{

  List<String> categoryList = [];
  List<ProductModel> allProductList = [];
  List<ProductModel> allMacProductList = [];
  List<ProductModel> alliPhoneProductList = [];
  List<ProductModel> allOthersProductList = [];

  void getAllCategories(){
    FirestoreHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length, (index) => snapshot.docs[index].data()['name']);
      notifyListeners();
    });
  }

  Future<void> addProduct(ProductModel productModel) => FirestoreHelper.uploadProduct(productModel);

  void getAllProducts(){
    FirestoreHelper.getAllProducts().listen((snapshot) {
      allProductList = List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
  void getAllMacProducts(){
    FirestoreHelper.getAllMacProducts().listen((snapshot) {
      allMacProductList = List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
  void getAllOtherProducts(){
    FirestoreHelper.getAllOthersProducts().listen((snapshot) {
      allOthersProductList = List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
  void getAlliPhoneProducts(){
    FirestoreHelper.getAllPhoneProducts().listen((snapshot) {
      alliPhoneProductList = List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
}