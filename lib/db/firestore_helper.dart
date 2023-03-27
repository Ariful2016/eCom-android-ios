

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_firebase/models/ProductModel.dart';
import 'package:ecom_firebase/models/user.dart';
import 'package:ecom_firebase/pages/auth/firebase_auth_service.dart';

class FirestoreHelper{

  static const String _user = 'Users';
  static const String _collectionCategory = 'Categorites';
  static const String _collectionProducts = 'Products';

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() => _db.collection(_collectionCategory).snapshots();

  static Future<void> addUser( UserModel userModel){

    final docRef = _db.collection(_user).doc(FirebaseAuthService.currentUser!.uid);
    userModel.id = docRef.id;
    return docRef.set(userModel.toMap());
  }


  static Future<void> updateProfilePic(UserModel userModel){
    return _db.collection(_user).doc(FirebaseAuthService.currentUser!.uid).update(userModel.toMap());
  }
  static Future<void> uploadProduct(ProductModel productModel){
    final docRef = _db.collection(_collectionProducts).doc();
    productModel.id = docRef.id;
    return docRef.set(productModel.toMap());
  }
  
  static Future<QuerySnapshot<Map<String, dynamic>>> getCurrentUser() =>
      _db.collection(_user).where('id', isEqualTo: FirebaseAuthService.currentUser!.uid).get();


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(_collectionProducts).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMenProducts() =>
      _db.collection(_collectionProducts)
          .where('category', isEqualTo: 'men')
          .snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOthersProducts() =>
      _db.collection(_collectionProducts)
          .where('category', isEqualTo: 'others')
          .snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPhoneProducts() =>
      _db.collection(_collectionProducts)
          .where('category', isEqualTo: 'iphone')
          .snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMacProducts() =>
      _db.collection(_collectionProducts)
          .where('category', isEqualTo: 'mac')
          .snapshots();
}