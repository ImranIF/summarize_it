import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:summarize_it/authentication/auth_page.dart';
import 'package:summarize_it/authentication/auth_service.dart';
import 'package:summarize_it/authentication/registerpage.dart';
import 'package:summarize_it/components/custombutton.dart';
import 'package:summarize_it/components/customtextfield.dart';
import 'package:summarize_it/components/sessionmanager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final String welcomeMsg = 'Welcome back! You have been missed';
  final String accountCreateMsg = "Don't have an account? Create one today!";
  bool forgotPassword = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signUserIn() async {
    if (_areAllFieldsFilled()) {
      await SessionManager.init();
      // Show loading circle
      setState(() {
        isLoading = true;
      });

      try {
        final response = await AuthService().signInWithEmailPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        setState(() {
          isLoading = false;
        });

        if (response?.user != null) {
          // Check if email is verified (Supabase handles this automatically)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AuthPage()),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        
        print('Login error: $e');
        
        // Handle different types of errors
        String errorMessage = 'Login failed. Please check your credentials.';
        if (e.toString().contains('Invalid login credentials')) {
          errorMessage = 'Invalid email or password. Please try again.';
        } else if (e.toString().contains('Email not confirmed')) {
          errorMessage = 'Please verify your email before signing in.';
        } else if (e.toString().contains('Too many requests')) {
          errorMessage = 'Too many attempts. Please try again later.';
        }
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error', textAlign: TextAlign.center),
            content: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color.fromARGB(255, 52, 110, 91)),
            ),
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

  Future<void> checkEmailVerification(timer) async {
    // Supabase handles email verification automatically
    // This method is no longer needed but keeping for compatibility
    timer.cancel();
  }

  Future<void> signIn(BuildContext context) async {
    // This method is replaced by signUserIn() above
  }

  void wrongInputCredentialMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error', textAlign: TextAlign.center),
            content: Text(
              'Incorrect Email or Password. Please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromARGB(255, 52, 110, 91)),
            ),
          );
        });
  }

  bool _areAllFieldsFilled() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                  colors: const [
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
          child: signInForm(context)),
    ));
  }

  SafeArea signInForm(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Center(
        child: isLoading
            ? Lottie.asset(
                'assets/Loading-anim.json',
                width: 200,
                height: 205,
                frameRate: const FrameRate(60),
                animate: true,
              )
            : ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(50),
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: GradientIcon(
                      icon: Icons.lock_rounded,
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
                        text: 'LOGIN',
                        onPressed: signUserIn,
                        hpadding: 15,
                        wpadding: 15,
                        borderRadius: 15.0,
                        color: const Color.fromARGB(255, 16, 58, 40)),
                  ),
                  const SizedBox(height: 5),
                  CheckboxListTile(
                    contentPadding: const EdgeInsets.all(0),
                    visualDensity: VisualDensity.compact,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'Forgot Password? ',
                      style: GoogleFonts.merriweather(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    value: forgotPassword,
                    onChanged: (newValue) {
                      setState(() {
                        forgotPassword = newValue!;
                      });
                    },
                  ),
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
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final response = await AuthService().signInWithGoogle();
                            setState(() {
                              isLoading = false;
                            });

                            if (response?.user != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AuthPage(),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            print('Google sign in error: $e');
                            
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content: Text('Google sign in failed: ${e.toString()}'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
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
                        text: 'Sign in with Facebook',
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final response = await AuthService().signInWithFacebook(context);
                            setState(() {
                              isLoading = false;
                            });

                            if (response?.user != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AuthPage(),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            print('Facebook sign in error: $e');
                            
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content: Text('Facebook sign in failed: ${e.toString()}'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
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
                              builder: (context) => const RegisterPage(),
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
}
