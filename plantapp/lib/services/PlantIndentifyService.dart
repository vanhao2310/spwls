import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlantIdentifyService {
  static Future<String?> identifyPlant(String base64Image) async {
    final headers = {
      'Api-Key': dotenv.env['PLANTID_API_KEY'] ?? '',
      'Content-Type': 'application/json',
    };

    final requestBody = json.encode({
      "images": ["data:image/jpg;base64,$base64Image"],
      "latitude": 49.207,
      "longitude": 16.608,
      "similar_images": true,
    });
    final api_url = dotenv.env['PLANTID_API_URL'] ?? '';
    final url = Uri.parse(
        "$api_url/identification?details=common_names,url,description,taxonomy,synonyms,watering,best_light_condition,best_soil_type,common_uses,cultural_significance,toxicity,best_watering&language=en");
    final request = http.Request('POST', url);
    request.headers.addAll(headers);
    request.body = requestBody;

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      print('Response: $responseBody');
      return responseBody;
    } else {
      print('Error in service: ${response.reasonPhrase}');
      return null;
    }
  }
}