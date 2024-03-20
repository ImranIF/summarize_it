import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summarize_it/models/textsummarizationmodel.dart';
import 'package:summarize_it/pages/help.dart';

class Summarizer extends StatefulWidget {
  Summarizer({super.key});

  @override
  State<Summarizer> createState() => _SummarizerState();
}

class _SummarizerState extends State<Summarizer> {
  final TextEditingController inputController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TextSummarizationModel(),
      builder: (context, _) => Scaffold(
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
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: FloatingActionButton.small(
                              backgroundColor:
                                  Color.fromARGB(255, 162, 236, 169),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Help())),
                              child: const Icon(
                                Icons.help_outline_outlined,
                                color: Color.fromARGB(255, 76, 175, 162),
                              )),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Summarize Engine',
                            style: GoogleFonts.cormorantSc().copyWith(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: const Color.fromARGB(255, 101, 182, 144),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          textAlign: TextAlign.left,
                          controller: inputController,
                          maxLines: 8,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 100, 52, 34),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 34, 96, 100),
                              ),
                            ),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Enter text to summarize",
                            labelStyle: TextStyle(
                              color: Colors.brown.shade800,
                            ),
                            fillColor: const Color.fromARGB(255, 177, 226, 211)
                                .withOpacity(0.5),
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Material(
                          borderRadius: BorderRadius.circular(24.0),
                          child: InkWell(
                            onTap: () => summarizeText(context),
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0)),
                            child: Ink(
                              padding: const EdgeInsets.only(
                                  top: 12.0,
                                  bottom: 12.0,
                                  left: 18.0,
                                  right: 18.0),
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
                              child: isLoading
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Summarizing your text. Please wait...',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 100, 52, 34),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                              backgroundColor:
                                                  Colors.lightBlueAccent,
                                              strokeWidth: 3,
                                            ))
                                      ],
                                    )
                                  : const Text(
                                      'Summarize Text',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 100, 52, 34),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Consumer<TextSummarizationModel>(
                          builder: (context, model, child) {
                            return model.outputText.isNotEmpty
                                ? GestureDetector(
                                    onTap: () async {
                                      await Clipboard.setData(
                                        ClipboardData(text: model.outputText),
                                      );
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          model.outputText,
                                          style: GoogleFonts.georama(
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                                255, 70, 69, 69),
                                          ),
                                        )
                                        // child: Text(
                                        // model.outputText,
                                        // style: TextStyle(
                                        //   color: Color.fromARGB(255, 100, 52, 34),
                                        //   fontSize: 14,
                                        //   fontWeight: FontWeight.bold,
                                        // ),
                                        // ),
                                        ),
                                  )
                                : const SizedBox();
                          },
                        )
                      ])),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> summarizeText(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final model = Provider.of<TextSummarizationModel>(context, listen: false);

    // showDialog(
    //   context: context,
    //   builder: (context) => const Center(
    //     child: CircularProgressIndicator(),
    //   ),
    // );

    final response = await http.post(
      Uri.parse(
          "https://api-inference.huggingface.co/models/facebook/bart-large-cnn"),
      headers: {
        "Authorization":
            "Bearer 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", // Replace with your actual API token
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: utf8.encode(jsonEncode({"inputs": inputController.text})),
    );

    print("Request Body: ${jsonEncode({"inputs": inputController.text})}");
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);

      if (responseData is List<dynamic> && responseData.isNotEmpty) {
        final Map<String, dynamic> summaryData = responseData[0];

        if (summaryData.containsKey("summary_text")) {
          model.setOutputText(summaryData["summary_text"] ?? "");
        } else {
          print("Error: 'summary_text' field not found in the response");
        }
      } else {
        print("Error: Unexpected response format");
      }
    } else {
      print("Error: ${response.reasonPhrase}");
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Error',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromARGB(255, 31, 140, 155)),
          ),
          content: Text(
            "Please provide valid input and ensure you have a stable Internet Connection running!",
            textAlign: TextAlign.center,
            style: GoogleFonts.merriweather(
              fontSize: 16,
              color: Color.fromARGB(255, 100, 52, 34),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}
