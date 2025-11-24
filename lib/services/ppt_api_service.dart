import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ppt_request_model.dart';

class PptApiService {
  static const String _baseUrl =
      'https://api.magicslides.app/public/api/ppt_from_topic';

  // Fallback URL to use when API returns empty or null URL
  static const String fallbackPptUrl =
      'https://cdn.drissea.com/IndianAppGuyHireMeNow92915500b9547831.pptx';

  // Generate PPT
  Future<String> generatePPT(PPTRequestModel request) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // The API response structure:
        // {
        //   "status": "success",
        //   "data": {
        //     "url": "...", // PPTX
        //     "pdfUrl": "...", // PDF
        //     ...
        //   }
        // }
        print(body);

        if (body['status'] == 'success' && body['data'] != null) {
          final data = body['data'];
          final String pptUrl = data['url'] ?? '';
          final String pdfUrl = data['pdfUrl'] ?? '';

          // Use fallback URL if API returns empty or null URL
          final String finalPptUrl = (pptUrl.isEmpty) ? fallbackPptUrl : pptUrl;
          print(finalPptUrl);

          return finalPptUrl;
        } else {
          throw Exception('API returned status: ${body['status']}');
        }
      } else {
        throw Exception('Failed to generate PPT: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating PPT: $e');
    }
  }
}
