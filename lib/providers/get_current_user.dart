import 'package:dbu_push/models/user.dart';
import 'package:dbu_push/utils/helpers/firestore_cloud_reference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class GetCurrentUser with ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  void getCurrentUser(AsyncSnapshot<User?> snapshot) {
    final doc = usersDoc.where('email', isEqualTo: snapshot.data?.email).get();
    doc.then(
      (snapshot) => {
        snapshot.docs.forEach((element) async {
          // await usersDoc.doc(element.id).update({
          // });
          _currentUser = UserModel.fromDocument(element);
          notifyListeners();
        })
      },
    );
  }
}
