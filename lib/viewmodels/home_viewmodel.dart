import 'package:flutter/material.dart';
import '../models/ppt_request_model.dart';
import '../services/ppt_api_service.dart';
import '../services/storage_service.dart';
import 'dart:io';

class HomeViewModel extends ChangeNotifier {
  final PptApiService _pptApiService = PptApiService();
  final StorageService _storageService = StorageService();

  bool _isLoading = false;
  String? _errorMessage;
  File? _downloadedFile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  File? get downloadedFile => _downloadedFile;

  String? _pptUrl;
  String? get pptUrl => _pptUrl;

  // Generate PPT
  Future<bool> generatePPT({
    required String topic,
    required String email,
    required String accessId,
    required String template,
    // required String mode, // Removed as per new API spec
    required int slideCount,
    required String language,
    required bool aiImages,
    required bool imageForEachSlide, // Renamed from imageOnEachSlide
    required bool googleImage, // Renamed from googleImages
    required bool googleText,
    required String model,
    required String presentationFor,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    _downloadedFile = null;
    _pptUrl = null;

    try {
      final request = PPTRequestModel(
        topic: topic,
        email: email,
        accessId: accessId,
        template: template,
        // mode: mode,
        slideCount: slideCount,
        language: language,
        aiImages: aiImages,
        imageForEachSlide: imageForEachSlide,
        googleImage: googleImage,
        googleText: googleText,
        model: model,
        presentationFor: presentationFor,
      );

      final Map<String, String> urls =
          await _pptApiService.generatePPT(request);
      _pptUrl = urls['ppt'];
      final String? pdfUrl = urls['pdf'];

      if (pdfUrl != null && pdfUrl.isNotEmpty) {
        // Generate a filename based on topic and timestamp
        final String fileName =
            'ppt_${DateTime.now().millisecondsSinceEpoch}.pdf';

        _downloadedFile = await _storageService.downloadFile(
          pdfUrl,
          fileName,
        );
        return true;
      } else {
        // If no PDF, we can't preview it in the app as is, but generation was successful.
        // We might want to handle this case in UI (e.g. show "Download PPT" only).
        // For now, let's consider it a success if we have a PPT url, but we won't have a file to preview.
        if (_pptUrl != null && _pptUrl!.isNotEmpty) {
          return true;
        }
        _errorMessage = "No PDF or PPT URL returned";
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
