import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:summarize_it/components/pdfapi.dart';
import 'package:summarize_it/pages/pdfviewerpage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class DemographicChartData {
  DemographicChartData({this.x, this.y});
  final DateTime? x;
  final int? y;
}

class _ReportState extends State<Report> {
  List<DemographicChartData> demographicChartData = <DemographicChartData>[];
  bool isLoading = false;
  String bartReport =
      '''BART (Bidirectional and Auto-Regressive Transformers) is trained on a large corpus of text data using a denoising auto-encoder objective. 
It is a powerful model that can be used for natural language processing tasks, e.g: text summarization, translation, and others.
The one used for text summarization is fine-tuned on CNN Daily Mail dataset and has obtained a BLEU score: 55.71.''';

  @override
  void initState() {
    super.initState();
    getDemographicDataFromFirestore();
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
                      child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Crystal Report",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 100, 52, 34)),
                    ),
                    const SizedBox(height: 20),
                    SfCartesianChart(
                      title: ChartTitle(
                          text: 'Posts by User Demographics',
                          textStyle: GoogleFonts.georama().copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 59, 107, 85))),
                      plotAreaBorderWidth: 2,
                      primaryXAxis: const DateTimeAxis(),
                      primaryYAxis: const NumericAxis(),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true,
                        enablePanning: true,
                        enableDoubleTapZooming: true,
                        enableSelectionZooming: true,
                      ),
                      series: <LineSeries<DemographicChartData, DateTime>>[
                        LineSeries<DemographicChartData, DateTime>(
                            dataSource: demographicChartData,
                            xValueMapper: (DemographicChartData data, _) =>
                                data.x,
                            yValueMapper: (DemographicChartData data, _) =>
                                data.y)
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('BART Model for Text Summarization',
                        style: GoogleFonts.georama().copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 59, 107, 85))),
                    const SizedBox(height: 15),
                    Text(bartReport,
                        maxLines: 7,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.georama().copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 74, 136, 107))),
                    const SizedBox(height: 15),
                    Material(
                      borderRadius: BorderRadius.circular(24.0),
                      child: InkWell(
                        onTap: () async {
                          // _openPdf(context,
                          //     'assets/Analysis-of-Extractive-Text-Summarization.pdf');
                          // PdfDocument document = PdfDocument(
                          //     inputBytes: File(
                          //             'assets/Analysis-of-Extractive-Text-Summarization.pdf')
                          //         .readAsBytesSync());
                          // OpenFile.open(
                          //     'assets/Analysis-of-Extractive-Text-Summarization.pdf');

                          // PdfDocument document = PdfDocument(
                          //     inputBytes: File(
                          //             'assets/Analysis-of-Extractive-Text-Summarization.pdf')
                          //         .readAsBytesSync());

                          // PdfDocument document = PdfDocument(
                          //     inputBytes: File(
                          //             'assets/Analysis-of-Extractive-Text-Summarization.pdf')
                          //         .readAsBytesSync());

                          setState(() {
                            isLoading = true;
                          });
                          const url =
                              'https://www.arxiv.org/pdf/1910.13461.pdf';
                          final file = await PDFApi.loadNetwork(url);

                          openPDF(context, file);
                          setState(() {
                            isLoading = false;
                          });
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
                            child: isLoading
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Loading...',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 34, 79, 100),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          strokeWidth: 4,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Check here for a detailed report',
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
              ))))),
    );
  }

  Future<void> getDemographicDataFromFirestore() async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('dateOfBirth, postCount')
          .not('dateOfBirth', 'is', null)
          .neq('dateOfBirth', '')
          .order('dateOfBirth', ascending: false);

      List<DemographicChartData> list =
          response.map<DemographicChartData>((user) {
        print('-------------------${user['postCount']}-------------------');

        DateTime dateOfBirth;
        try {
          dateOfBirth = DateTime.parse(user['dateOfBirth']);
        } catch (e) {
          dateOfBirth = DateTime.now();
        }

        return DemographicChartData(
          x: dateOfBirth,
          y: user['postCount'] ?? 0,
        );
      }).toList();

      setState(() {
        demographicChartData = list;
      });
    } catch (e) {
      print('Error fetching demographic data: $e');
    }
  }
}
// Future<void> _openPdf(BuildContext context, String assetPath) async {
//   try {
//     final ByteData data = await rootBundle.load(assetPath);
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PdfViewer(pdfData: data.buffer.asUint8List()),
//       ),
//     );
//   } catch (e) {
//     print("Error opening PDF: $e");
//     // Handle error opening PDF
//   }
// }

void openPDF(BuildContext context, File file) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(file: file),
    ),
  );
}

// class PdfViewer extends StatelessWidget {
//   final Uint8List pdfData;

//   const PdfViewer({required this.pdfData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: PDFView(
//         filePath: '',
//         pdfData: pdfData,
//       ),
//     );
//   }
// }
