import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullName;
  final String userName;
  final String address;
  final Timestamp dateOfBirth;
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
      'dateOfBirth': dateOfBirth,
      'email': email,
      'password': password,
      'imageURL': imageURL,
      'postCount': postCount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'],
      userName: map['userName'],
      address: map['address'],
      dateOfBirth:
          map['dateOfBirth'] == '' ? Timestamp.now() : map['dateOfBirth'],
      email: map['email'],
      password: map['password'],
      imageURL: map['imageURL'],
      postCount: map['postCount'],
    );
  }

  static Future<UserModel> getUserData(String email) async {
    print('----------------email: $email--------------------');
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}
