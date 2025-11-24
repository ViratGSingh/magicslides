import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  final Dio _dio = Dio();

  // Download file from URL and save locally
  Future<File> downloadFile(String url, String fileName) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String savePath = '${appDocDir.path}/$fileName';

      await _dio.download(url, savePath);
      return File(savePath);
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  // Get local file path
  Future<String> getLocalFilePath(String fileName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    return '${appDocDir.path}/$fileName';
  }
}
