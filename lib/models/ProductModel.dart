
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{

  String? id;
  String? name;
  String? category;
  String? description;
  String? imageUrl;
  num? price;
  bool isAvailable = true;
  Timestamp? timestamp;

  ProductModel({
      this.id,
      this.name,
      this.category,
      this.description,
      this.imageUrl,
      this.price,
      this.isAvailable = true,
      this.timestamp,
      });

  Map<String, dynamic> toMap(){
    var map = <String,dynamic>{
      'id' : id,
      'nane' : name,
      'category' : category,
      'description' : description,
      'imageUrl' : imageUrl,
      'price' : price,
      'isStock' : isAvailable,
      'uploadTime' : timestamp
    };
    return map;
  }

  factory ProductModel.fromMap(Map<String, dynamic> map ) => ProductModel(
    id : map['id'],
    name : map['nane'],
    category : map['category'],
    description : map['description'],
    imageUrl : map['imageUrl'],
    price : map['price'],
    isAvailable : map['isStock'],
    timestamp : map['uploadTime'],
  );



}