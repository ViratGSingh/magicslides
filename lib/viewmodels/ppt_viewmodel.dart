import 'package:flutter/material.dart';
import 'dart:io';

class PptViewModel extends ChangeNotifier {
  // This ViewModel can be used to manage the state of the ResultView
  // For example, handling file loading, page navigation in PDF, etc.

  File? _pptFile;

  File? get pptFile => _pptFile;

  void setFile(File file) {
    _pptFile = file;
    notifyListeners();
  }

  // Add other PPT related logic here if needed
}
