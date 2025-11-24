import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ppt_request_model.dart';

class PptApiService {
  static const String _baseUrl =
      'https://api.magicslides.app/public/api/ppt_from_topic';

  // Generate PPT
  Future<Map<String, String>> generatePPT(PPTRequestModel request) async {
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

          if (pptUrl.isNotEmpty) {
            return {
              'ppt': pptUrl,
              'pdf': pdfUrl, // Might be empty if not available
            };
          } else {
            throw Exception('API response did not contain a PPT URL');
          }
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
