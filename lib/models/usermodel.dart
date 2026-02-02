import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String fullName;
  final String userName;
  final String address;
  final DateTime dateOfBirth;
  final String email;
  final String password;
  final String imageURL;
  final int postCount;

  UserModel({
    required this.fullName,
    required this.userName,
    required this.address,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    required this.imageURL,
    required this.postCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'userName': userName,
      'address': address,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'email': email,
      'password': password,
      'imageURL': imageURL,
      'postCount': postCount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] ?? '',
      userName: map['userName'] ?? '',
      address: map['address'] ?? '',
      dateOfBirth: map['dateOfBirth'] != null && map['dateOfBirth'] != ''
          ? DateTime.parse(map['dateOfBirth'])
          : DateTime.now(),
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      imageURL: map['imageURL'] ?? '',
      postCount: map['postCount'] ?? 0,
    );
  }

  static Future<UserModel> getUserData(String email) async {
    print('----------------email: $email--------------------');
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('email', email)
          .single();

      return UserModel.fromMap(response);
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
