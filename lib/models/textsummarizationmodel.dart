import 'package:flutter/material.dart';

class TextSummarizationModel extends ChangeNotifier {
  String _inputText = '';
  String _outputText = '';

  String get inputText => _inputText;
  String get outputText => _outputText;

  void setInputText(String text) {
    _inputText = text;
    notifyListeners();
  }

  void setOutputText(String text) {
    _outputText = text;
    notifyListeners();
  }
}
