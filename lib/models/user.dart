import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String uId;
  final String role;
  final String channelId;
  final String avatar;
  final String bio;
  final bool isActive;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.uId,
    required this.role,
    required this.channelId,
    required this.avatar,
    required this.bio,
    required this.isActive,
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
  }
}
