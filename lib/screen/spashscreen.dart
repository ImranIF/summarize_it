import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summarize_it/authentication/auth_page.dart';
import 'package:summarize_it/authentication/loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  String summary =
      '''Read Less, Know More!\nYour Comprehensive AI Text Summarizer''';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
      reverseDuration: const Duration(seconds: 3),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // PopScope is a custom widget to disable back button
      canPop: false, // disable back button
      onPopInvoked: (_) async {
        // on back button pressed
        await _displayExitDialog();
      },
      child: Scaffold(
        // Scaffold is a widget that provides default app bar, background color, etc.
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/summarize-it-splash.json',
                fit: BoxFit.fill,
                // height: MediaQuery.of(context).size.height * 0.3,
                // width: MediaQuery.of(context).size.width * 0.75,
                width: 250,
                height: 205,
                frameRate: const FrameRate(60),
                animate: true,
                repeat: false,
                controller: _animationController,
              ),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                text: 'Summarize It',
                style: GoogleFonts.georama(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2.5,
                ),
              )),
              const SizedBox(height: 15),
              // divider
              Image.asset('assets/line.png',
                  width: MediaQuery.of(context).size.width * 0.5),
              const SizedBox(height: 10),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    summary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.georama(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 70, 69, 69),
                      letterSpacing: 1.5,
                    ),
                  )),
              const SizedBox(height: 10),
              Image.asset('assets/line.png',
                  width: MediaQuery.of(context).size.width * 0.5),
              const SizedBox(height: 10),
              const ClickHere(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _displayExitDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text(
            'Exit Summarize It',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromARGB(255, 31, 140, 155)),
          ),
          content: const Text("Are you sure you want to exit?"),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.green),
                )),
            ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red.shade700),
                )),
          ]),
    );
  }
}

class ClickHere extends StatefulWidget {
  const ClickHere({super.key});

  @override
  State<ClickHere> createState() => _ClickHereState();
}

class _ClickHereState extends State<ClickHere> {
  bool isWidgetVisible = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isWidgetVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isWidgetVisible
        ? InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(PageRouteBuilder(pageBuilder: (context, animation, _) {
                return const AuthPage();
              }));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const AuthPage(),
              //     ));
            },
            child: Lottie.asset(
              'assets/click-here-to-enter.json',
              fit: BoxFit.fill,
              height: 50.0,
              width: 50.0,
              frameRate: const FrameRate(60),
              // controller: animationController,
              animate: true,
            ),
          )
        : const SizedBox(
            height: 50.0,
          );
  }
}
