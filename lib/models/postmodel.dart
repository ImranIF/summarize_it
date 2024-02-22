import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String title;
  final String description;
  final 

  PostModel({this.title, this.description, this.imageUrls});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      title: map['title'],
      description: map['description'],
      imageUrls: List<String>.from(map['imageUrls']),
    );
  }

  Future<void> saveToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .add(toMap());
    } catch (e) {
      // Handle error
      print('Error saving post to Firestore: $e');
    }
  }
}
