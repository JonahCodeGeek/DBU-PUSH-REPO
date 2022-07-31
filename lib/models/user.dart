import 'package:cloud_firestore/cloud_firestore.dart';
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
  }
}
