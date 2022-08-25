import 'package:dbu_push/models/user.dart';
import 'package:dbu_push/utils/helpers/firestore_cloud_reference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class GetCurrentUser with ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  void getCurrentUser(AsyncSnapshot<User?> snapshot) {
    // final doc = usersDoc.where('email', isEqualTo: snapshot.data?.email).get();
    final doc = usersDoc.where('id', isEqualTo: snapshot.data?.uid).get();
    doc.then(
      (snapshot) => {
        snapshot.docs.forEach((element) async {
          _currentUser = UserModel.fromDocument(element);
          notifyListeners();
        })
      },
    );
  }
}

class GetUsers with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  void getUser(UserModel? snapshot){
    final doc = usersDoc.where('id', isEqualTo:snapshot?.id).get();
     doc.then((snapshot) => {
          snapshot.docs.forEach((element) {
            _user = UserModel.fromDocument(element);
          })
        }
        );
  }
}
