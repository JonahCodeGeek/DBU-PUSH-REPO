import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
import 'package:flutter/material.dart';

class Users {
  final String? email, fullName, bio, avatar, role;
  final bool? isActive;
  Users(
      {this.email,
      this.fullName,
      this.avatar,
      this.role,
      this.isActive,
      this.bio});

  factory Users.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Users(
      email: data?['email'],
      fullName: data?['fullName'],
      avatar: data?['avatar'],
      role: data?['role'],
      isActive: data?['isActive'],
      bio: data?['bio'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (avatar != null) 'avatar': avatar,
      if (role != null) 'role': role,
      if (isActive != null) 'isActive': isActive,
      if (bio != null) 'bio': bio,
    };
=======

class User {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? uId;
  final String? role;
  final String? channelId;
  final String? avatar;
  final String? bio;
  final bool? isActive;

  User({
     this.id,
     this.fullName,
     this.email,
     this.phone,
     this.uId,
     this.role,
     this.channelId,
     this.avatar,
     this.bio,
     this.isActive,
  });
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc.get('id'),
        fullName: doc.get('fullName'),
        email: doc.get('email'),
        phone: doc.get('phone'),
        uId: doc.get('uId'),
        role: doc.get('role'),
        channelId: doc.get('channelId'),
        avatar: doc.get('avatar'),
        bio: doc.get('bio'),
        isActive: doc.get('isActive'));
>>>>>>> b748a7dd281c4f94f1b6c8385c9f86f49d15e018
  }
}
