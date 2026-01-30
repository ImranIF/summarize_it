import 'package:flutter/material.dart';
import 'package:summarize_it/models/usermodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get getUser => _supabase.auth.currentUser;

  Future<void> getUserInfo() async {
    final currentUser = getUser;
    if (currentUser != null && currentUser.email != null) {
      print('----------------user:--------------------');
      userModel = await UserModel.getUserData(currentUser.email!);
      print('----------------userModel: $userModel--------------------');
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    userModel = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return _supabase.auth.currentUser != null;
  }
}
