import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  YoutubePlayerController? youtubeController;

  @override
  void initState() {
    super.initState();
    youtubeController = YoutubePlayerController(
      initialVideoId: 't45S_MwAcOw',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 162, 236, 169),
              Color.fromARGB(255, 92, 175, 170),
              // Color.fromARGB(10, 52, 59, 53),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: SafeArea(
            maintainBottomViewPadding: true,
            child: Center(
              child: SingleChildScrollView(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(50),
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          'Overview of BERT used in Text Summarization',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantSc().copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: Color.fromARGB(255, 82, 148, 117),
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: YoutubePlayer(
                        controller: youtubeController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.amber,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.amber,
                          handleColor: Colors.amberAccent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
