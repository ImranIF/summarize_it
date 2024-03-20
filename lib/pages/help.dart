import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summarize_it/components/custombutton.dart';
import 'package:summarize_it/components/pdfapi.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:pdf/pdf.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  YoutubePlayerController? youtubeController;
  String? faqCategory;
  String? questiontype;

  final Map<String, List<String>> questiontypeOptions = {
    'Summarization issues': [
      "Can't see any output?",
      'No sematic meaning',
      'Excessive repetition',
    ],
    'Post Management': [
      "How to create post?",
      "Can't find my posts?",
      "How to like or comment?"
    ],
  };

  final Map<String, String> questiontypeAnswer = {
    "Can't see any output?":
        "Make sure you have entered text and have stable internet connection. If the issue persists, please contact the support team.",
    'No sematic meaning':
        'Sometimes the model may not understand the context of the text due to input of complex words. Please make sure you have entered simpler texts and try again.',
    'Excessive repetition':
        'Words may be repeated due to the input text. Do make sure you have entered the correct text and try again.',
    "How to create post?":
        "Tap the + button on the Bottom Navigation Bar to navigate to the Create Post page. Fill in the details and tap the Post button on the page",
    "Can't find my posts?":
        'Make sure you have already posted using the app and have stable internet connection and try again.',
    "How to like or comment?":
        'Press the heart icon to like a post and press the comment icon to comment on the post.',
  };

  Color backgroundColor = Colors.white;

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
  void dispose() {
    youtubeController!.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
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
                              color: Color.fromARGB(255, 59, 107, 85),
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
                        height: 15.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(24.0),
                            child: InkWell(
                              onTap: () async {
                                final pdfFile =
                                    await PDFApi.generateCenteredText(
                                        'Sample Text');
                              },
                              customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Ink(
                                  padding: const EdgeInsets.only(
                                      top: 12.0,
                                      bottom: 12.0,
                                      left: 19.0,
                                      right: 19.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.0),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 111, 199, 158),
                                          Color.fromARGB(255, 101, 182, 144),
                                          // Colors.lightBlueAccent[500]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Generate Crystal Report',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 34, 79, 100),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'FAQ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cormorantSc().copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: const Color.fromARGB(255, 66, 119, 94),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  value: faqCategory,
                                  items: questiontypeOptions.keys
                                      .map((String e) =>
                                          DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      faqCategory = value!;
                                      // questiontype =
                                      //     questiontypeOptions[value]![0];
                                      questiontype = null;
                                    });
                                  },
                                  hint: const Text('Select FAQ Category'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (faqCategory != null && faqCategory!.isNotEmpty)
                        const SizedBox(height: 15.0),
                      if (faqCategory != null && faqCategory!.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  height: 100,
                                  alignedDropdown: true,
                                  child: DropdownButton<String>(
                                    value: questiontype,
                                    items: questiontypeOptions[faqCategory]!
                                        .map((String e) =>
                                            DropdownMenuItem<String>(
                                              value: e,
                                              child: Text(e),
                                            ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        questiontype = value!;
                                      });
                                    },
                                    hint: const Text('Select Question type'),
                                    disabledHint:
                                        const Text('Select FAQ Category first'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (questiontype != null && questiontype!.isNotEmpty)
                        const SizedBox(height: 15.0),
                      if (questiontype != null && questiontype!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 76, 175, 150),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 15.0,
                                spreadRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Text(
                            questiontypeAnswer[questiontype]!,
                            style: GoogleFonts.cormorant().copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: const Color.fromARGB(255, 66, 119, 94),
                            ),
                          ),
                        ),
                      ],
                    ]),
              ),
            ),
          )),
    );
  }
}
