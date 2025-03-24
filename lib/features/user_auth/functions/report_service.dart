import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportService {
  static const String baseUrl = "http://192.168.127.233:8000"; // Replace with your backend URL
  static const String apiKey = "YmrKZ_uI47aTP5OuwlZTiZPF3MpR3G-TeSg4XP_GfNQ"; // Replace with your actual API key

  static Future<String?> generateReport(
      String symptomPrediction, Map<String, dynamic> xrayPrediction) async {
    try {
      final Uri url = Uri.parse("$baseUrl/generate-report");

      final Map<String, dynamic> requestBody = {
        "symptom_prediction": symptomPrediction,
        "xray_prediction": xrayPrediction,
      };

      final http.Response response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "API-Key": apiKey, // Pass API key for authentication
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data["report"] ?? "Report generation failed.";
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return "Failed to generate report. Please try again.";
      }
    } catch (e) {
      print("Error generating report: $e");
      return "An error occurred while generating the report.";
    }
  }
}
