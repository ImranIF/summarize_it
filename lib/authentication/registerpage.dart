import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:summarize_it/authentication/loginpage.dart';
import 'package:summarize_it/components/custombutton.dart';
import 'package:summarize_it/components/customtextfield.dart';
import 'package:widget_zoom/widget_zoom.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final String welcomeMsg = "First time here? Let's create an account";
  final String accountCreateMsg = "Already have an account? Login here";
  bool staySignedIn = false;
  String? imageLocalPath;
  String checkName = '';
  bool uniqueUser = false;
  XFile? file;
  late String imgUrl;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  void signUp() async {
    if (_areAllFieldsFilled()) {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              // create user
              email: emailController.text.trim(),
              password: passwordController.text.trim());

      addUserDetails(userCredential.user!);
      // add user details
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error', textAlign: TextAlign.center),
          content: const Text(
              'Please fill all the required fields before submitting!'),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Okay',
                  style: TextStyle(color: Color.fromARGB(255, 52, 110, 91)),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Future<String> insertImage() async {
  //   if (file != null) {
  // final String imageName = 'image_${DateTime.now().millisecondsSinceEpoch}';
  // const String imageDirectory = 'Users/';
  // final photoRef =
  //     FirebaseStorage.instance.ref().child('$imageDirectory$imageName');
  // final uploadTask = photoRef.putFile(File(imageLocalPath!));
  // final snapshot = await uploadTask.whenComplete(() => null);
  // return imgUrl = await snapshot.ref.getDownloadURL();
  //   }
  //   return imgUrl = '';
  // }

  Future addUserDetails(User user) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    print('-----------------------------------------');
    // date of birth to timestamp
    Timestamp dob =
        Timestamp.fromDate(DateTime.parse(dateOfBirthController.text));

    // insert image
    final String imageName = 'image_${DateTime.now().millisecondsSinceEpoch}';
    const String imageDirectory = 'Users/';
    final photoRef =
        FirebaseStorage.instance.ref().child('$imageDirectory$imageName');
    final uploadTask = photoRef.putFile(File(imageLocalPath!));
    final snapshot = await uploadTask.whenComplete(() => null);
    imgUrl = await snapshot.ref.getDownloadURL();

    print('-----------------------------------------baka------------------');

    // add user details
    Map<String, dynamic> userData = {
      'fullName': fullNameController.text.trim(),
      'userName': userNameController.text.trim(),
      'address': addressController.text.trim(),
      'dateOfBirth': dob,
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'imageURL': imgUrl,
      'bio': '',
      'postCount': 0,
    };

    print('-----------------------------------------sussy------------');

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .set(userData);

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Registered!', textAlign: TextAlign.center),
        content: const Text('You have successfully created your account!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            ),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  bool _areAllFieldsFilled() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        fullNameController.text.isNotEmpty &&
        userNameController.text.isNotEmpty &&
        uniqueUser &&
        dateOfBirthController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        imageLocalPath != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 162, 236, 169),
            Color.fromARGB(255, 92, 175, 170),
            // Color.fromARGB(10, 52, 59, 53),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) {
            // return value < 1 ? const Skeletonizer() : signInForm(context);
            return ShaderMask(
              shaderCallback: (rect) {
                return RadialGradient(
                  radius: value * 5,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                    Colors.transparent
                  ],
                  stops: [0.0, 0.45, 0.60, 1.0],
                  center: FractionalOffset(0.50, 0.75),
                ).createShader(rect);
              },
              child: child,
            );
          },
          child: registerForm(context)),
    ));
  }

  SafeArea registerForm(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(50),
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: GradientIcon(
                icon: Icons.lock_open_rounded,
                gradient: LinearGradient(
                  colors: [
                    Colors.lightGreen.shade900,
                    Colors.lightGreen.shade800,
                    Colors.lightGreen.shade700,
                    Colors.lightGreen.shade600,
                  ],
                ),
                size: 100,
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              child: Align(
                alignment: Alignment.center,
                child: Text(welcomeMsg,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: GoogleFonts.merriweather(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    )),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Divider(
                color: Colors.grey.shade600,
                indent: 15,
                endIndent: 15,
              ),
            ),
            const SizedBox(height: 25),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imageLocalPath == null
                    ? Column(
                        children: [
                          Text(
                            'Insert Profile Picture',
                            style: GoogleFonts.merriweather(
                              fontSize: 12,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Icon(
                            Icons.photo,
                            size: 60,
                          ),
                        ],
                      )
                    : WidgetZoom(
                        heroAnimationTag: 'profile',
                        zoomWidget: Image.file(
                          File(imageLocalPath!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera,
                          color: Color.fromARGB(255, 12, 87, 105)),
                      label: const Text('Capture',
                          style: TextStyle(
                              color: Color.fromARGB(255, 12, 87, 105))),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.photo_album,
                          color: Color.fromARGB(255, 12, 87, 105)),
                      label: const Text(
                        'Gallery',
                        style:
                            TextStyle(color: Color.fromARGB(255, 12, 87, 105)),
                      ),
                    ),
                  ],
                ),
                if (imageLocalPath != null) ...[
                  const SizedBox(width: 5),
                  Text(file!.name,
                      style:
                          TextStyle(color: Colors.grey.shade800, fontSize: 10))
                ],
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: CustomTextField(false,
                    controller: fullNameController,
                    hintText: 'Imran Farid',
                    obscureText: false,
                    labelText: 'Name',
                    prefixIcon: Icons.person)),
            const SizedBox(height: 25),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: CustomTextFieldWithCheck(false,
                    controller: userNameController, onChanged: (value) async {
                  setState(() async {
                    setState(() {
                      checkName = value;
                    });
                    checkUsernameIsUnique(value);
                    setState(() {
                      // loading = false;
                    });
                  });
                },
                    hintText: 'imranif',
                    obscureText: false,
                    labelText: 'Username',
                    prefixIcon: Icons.verified_user_rounded)),
            (userNameController.text.isEmpty)
                ? const SizedBox()
                : (uniqueUser
                    ? SizedBox(
                        height: 20,
                        child: Text(
                          '*@$checkName already exists.',
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : SizedBox(
                        height: 20,
                        child: Text(
                          '@$checkName is available.',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 76, 135, 175),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
            const SizedBox(height: 25),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: CustomTextField(false,
                    controller: addressController,
                    hintText: 'BNS ISSA Khan, Chattogram',
                    obscureText: false,
                    labelText: 'Address',
                    prefixIcon: Icons.location_city_rounded)),
            const SizedBox(height: 25),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: CustomTextFieldWithFunction(true, datePicker,
                    controller: dateOfBirthController,
                    hintText: '',
                    obscureText: false,
                    labelText: 'Date of Birth',
                    prefixIcon: Icons.calendar_today_rounded)),
            const SizedBox(height: 25),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: CustomTextField(false,
                    controller: emailController,
                    hintText: 'imranfarid@yandex.com',
                    obscureText: false,
                    labelText: 'Email',
                    prefixIcon: Icons.email_rounded)),
            const SizedBox(height: 25),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: CustomTextField(false,
                    controller: passwordController,
                    hintText: '********',
                    obscureText: true,
                    labelText: 'Password',
                    prefixIcon: Icons.key_rounded)),
            const SizedBox(height: 25),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: CustomButton(
                  text: 'REGISTER',
                  onPressed: signUp,
                  hpadding: 15,
                  wpadding: 15,
                  borderRadius: 15.0,
                  color: const Color.fromARGB(255, 16, 58, 40)),
            ),
            const SizedBox(height: 5),
            SizedBox(
              child: Row(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.350,
                  child: Divider(
                    color: Colors.grey.shade600,
                    indent: 15,
                    endIndent: 15,
                  ),
                ),
                Text(
                  'Or',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.350,
                  child: Divider(
                    color: Colors.grey.shade600,
                    indent: 15,
                    endIndent: 15,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 15),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: CustomButtonWithIcon(
                  15.0,
                  Colors.black,
                  text: 'Sign in with Google',
                  onPressed: () {},
                  hpadding: 15,
                  wpadding: 15,
                  borderRadius: 15.0,
                  color: Colors.white,
                  icon: Image.asset("assets/google-image.png",
                      width: 25, height: 25),
                )),
            const SizedBox(height: 15),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: CustomButtonWithIcon(
                  15.0,
                  Colors.white,
                  text: 'Sign in with Facecbook',
                  onPressed: () {},
                  hpadding: 15,
                  wpadding: 15,
                  borderRadius: 15.0,
                  color: Colors.blue,
                  icon: Image.asset("assets/facebook-image.png",
                      width: 25, height: 25),
                )),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    accountCreateMsg,
                    style: GoogleFonts.merriweather(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 46, 125, 92),
                      textStyle: const TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Color.fromARGB(255, 52, 110, 91),
                      ),
                      // decoration: TextDecoration.combine([
                      //   TextDecoration.underline,
                      // ]),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  checkUsernameIsUnique(String username) async {
    QuerySnapshot querySnapshot;
    setState(() {
      // loading = true;
    });
    querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: username)
        .get();

    setState(() {
      uniqueUser = querySnapshot.docs.isNotEmpty;
    });

    setState(() {
      // loading = false;
    });
  }

  Future<void> datePicker() async {
    DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (datePicked != null) {
      setState(() {
        dateOfBirthController.text = datePicked.toString().substring(0, 10);
      });
    }
  }

  void getImage(ImageSource source) async {
    final imageFile =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (imageFile != null) {
      setState(() {
        imageLocalPath = imageFile.path;
        file = imageFile;
      });
    }
  }
}
