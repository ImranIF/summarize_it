import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:image_picker/image_picker.dart';
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
  XFile? file;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUp() async {}

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
      child: SafeArea(
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
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: CustomTextField(
                      controller: fullNameController,
                      hintText: 'Imran Farid',
                      obscureText: false,
                      labelText: 'Name',
                      prefixIcon: Icons.person)),
              const SizedBox(height: 25),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: CustomTextField(
                      controller: addressController,
                      hintText: 'BNS ISSA Khan, Chattogram',
                      obscureText: false,
                      labelText: 'Address',
                      prefixIcon: Icons.location_city_rounded)),
              const SizedBox(height: 25),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: CustomTextField(
                      controller: emailController,
                      hintText: 'imranfarid@yandex.com',
                      obscureText: false,
                      labelText: 'Email',
                      prefixIcon: Icons.email_rounded)),
              const SizedBox(height: 25),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: CustomTextField(
                      controller: passwordController,
                      hintText: '********',
                      obscureText: true,
                      labelText: 'Password',
                      prefixIcon: Icons.key_rounded)),
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
                          style: TextStyle(
                              color: Color.fromARGB(255, 12, 87, 105)),
                        ),
                      ),
                    ],
                  ),
                  if (imageLocalPath != null) ...[
                    const SizedBox(width: 5),
                    Text(file!.name,
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 10))
                  ],
                ],
              ),
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
              const SizedBox(height: 15),
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
      ),
    ));
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
