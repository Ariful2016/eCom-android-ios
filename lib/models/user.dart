

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? designation;
  String? address;
  String? imageUrl;
  Timestamp? createdAt;
  bool gender;

  UserModel({
    this.id,
    this.name,
    this.address,
    this.email,
    this.phone,
    this.designation,
    this.imageUrl,
    this.createdAt,
    this.gender = true
  });

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id' : id,
      'name' : name,
      'email' : email,
      'phone' : phone,
      'designation' : designation,
      'address' : address,
      'imageUrl' : imageUrl,
      'createAt' : createdAt,
      'gender' : gender
    };
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'],
    name: map['name'],
    email: map['email'],
    phone: map['phone'],
    designation: map['designation'],
    address: map['address'],
    imageUrl: map['imageUrl'],
    createdAt: map['createAt'],
    gender: map['gender'],
  );

  @override
  String toString() {
    return super.toString();
  }



}