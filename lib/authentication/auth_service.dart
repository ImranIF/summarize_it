import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';
import 'package:summarize_it/components/sessionmanager.dart';

class AuthService {
  signInWithFacebook(BuildContext context) async {
    await FacebookAuth.instance.logOut();
    // trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    print(
        '----------------facebookAuthCredential: $facebookAuthCredential--------------------');

    // sign in with credential
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      print('----------------user signed in--------------------');
      final User? user = userCredential.user;
      print('----------------user: $user--------------------');

      if (user != null) {
        // user is signed in

        // check if user email exists in firestore 'users' collection
        // if not, add user email to firestore 'users' collection
        // if yes, do nothing
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get()
            .then((doc) {
          if (!doc.exists) {
            FirebaseFirestore.instance.collection('users').doc(user.email).set({
              'fullName': user.displayName,
              'userName': user.displayName,
              'email': user.email,
              'address': '',
              'dateOfBirth': '',
              'password': '',
              'imageURL': user.photoURL,
              'postCount': 0,

              // 'email': user.email,
              // 'name': user.displayName,
              // 'photoUrl': user.photoURL,
              // 'createdAt': FieldValue.serverTimestamp(),
            });
          }
        });
        SessionManager.logIn();
        return userCredential;
      }
    } on Exception catch (e) {
      // TODO
      print(e);
      if (e.toString().contains('account-exists-with-different-credential')) {
        return showDialog(
            builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content:
                      const Text('Account exists with different credential'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'))
                  ],
                ),
            context: context);
      }
    }
  }

  signInWithGoogle() async {
    // clear any previous sign-in
    await GoogleSignIn().signOut();

    // begin interactive sign-in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // authenticate with google
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // create a credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // sign in with credential
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print('----------------user signed in--------------------');
      final User? user = userCredential.user;
      print('----------------user: $user--------------------');

      if (user != null) {
        // user is signed in

        // check if user email exists in firestore 'users' collection
        // if not, add user email to firestore 'users' collection
        // if yes, do nothing
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get()
            .then((doc) {
          if (!doc.exists) {
            FirebaseFirestore.instance.collection('users').doc(user.email).set({
              'fullName': user.displayName,
              'userName': user.displayName,
              'email': user.email,
              'address': '',
              'dateOfBirth': '',
              'password': '',
              'imageURL': user.photoURL,
              'postCount': 0,

              // 'email': user.email,
              // 'name': user.displayName,
              // 'photoUrl': user.photoURL,
              // 'createdAt': FieldValue.serverTimestamp(),
            });
          }
        });
        SessionManager.logIn();
        return userCredential;
      }
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }
}
