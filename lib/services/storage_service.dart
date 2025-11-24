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

  // Download file to user's visible folder (Downloads on Android, Documents on iOS)
  Future<String> downloadToUserFolder(String url, String fileName) async {
    try {
      Directory? directory;

      // For Android, use Downloads directory
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        // For iOS, use application documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      final String savePath = '${directory!.path}/$fileName';

      await _dio.download(
        url,
        savePath,
        options: Options(
          headers: {
            "User-Agent":
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                    "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "Accept": "*/*",
            "Connection": "keep-alive",
          },
          followRedirects: true,
          maxRedirects: 5,
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {}
        },
      );

      return savePath;
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  // Copy local file to user's visible folder
  Future<String> copyFileToUserFolder(
      String sourcePath, String fileName) async {
    try {
      Directory? directory;

      // For Android, use Downloads directory
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        // For iOS, use application documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      final String destinationPath = '${directory!.path}/$fileName';
      final File sourceFile = File(sourcePath);
      await sourceFile.copy(destinationPath);

      return destinationPath;
    } catch (e) {
      throw Exception('Failed to copy file: $e');
    }
  }
}
