import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    print('signing in with google');
    // clear any previous sign-in
    await GoogleSignIn().signOut();

    // begin interactive sign-in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    print('google user: $googleUser');
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
      final UserCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = UserCredential.user;

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
      }

      return UserCredential;
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }
}
