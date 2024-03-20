import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart';

class PDFApi {
  static Future<File> generateCenteredText(String text) async {
    final pdf = Document();

    return File('example.pdf').writeAsBytes(await pdf.save());
  }
}
