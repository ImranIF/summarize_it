import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

const summary =
    '''Read Less, Know More!\nYour comprehensive AI text summarizer''';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/summarize-it-splash.json',
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.3,
              frameRate: FrameRate(60),
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
                width: MediaQuery.of(context).size.width * 0.5)
          ],
        ),
      ),
    );
  }
}
