import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:summarize_it/models/usermodel.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;

  User get getUser => FirebaseAuth.instance.currentUser!;

  Future<void> getUserInfo() async {
    if (FirebaseAuth.instance.currentUser != null) {
      print('----------------user:--------------------');
      User user = getUser;
      userModel = await UserModel.getUserData(user.email!);
      print('----------------userModel: $userModel--------------------');
      notifyListeners();
    }
  }
}
