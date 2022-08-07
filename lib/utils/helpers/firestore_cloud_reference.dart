import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final usersDoc = FirebaseFirestore.instance.collection('users');
final storage = FirebaseStorage.instance.ref();