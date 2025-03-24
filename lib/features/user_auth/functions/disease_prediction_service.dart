import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// API Base URL - Replace with your actual backend IP and port
const String baseUrl = "http://192.168.127.233:8000"; // Replace with your computer's IP
const String apiKey = "YmrKZ_uI47aTP5OuwlZTiZPF3MpR3G-TeSg4XP_GfNQ"; // Replace with your actual API key
 

// Function to predict disease from text symptoms
Future<String> predictDisease(String symptoms) async {
  final String apiUrl = "$baseUrl/predict/symptoms";

  String trimmedSymptoms = symptoms.trim();
  if (trimmedSymptoms.isEmpty || trimmedSymptoms.split(' ').length < 3) {
    return "Please enter a more detailed description of your symptoms.";
  }

  try {
    print("📡 Sending request to: $apiUrl");
    print("📜 Request body: ${json.encode({"description": trimmedSymptoms})}");

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "API-Key": apiKey,
      },
      body: json.encode({"description": trimmedSymptoms}),
    );

    print("📡 Response Code: ${response.statusCode}");
    print("📡 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey("predicted_disease") && data["predicted_disease"].toString().isNotEmpty) {
        return "Predicted Condition: ${data["predicted_disease"]}";
      } else {
        return "No disease detected. Try providing more specific symptoms.";
      }
    } else {
      return "Server Error: ${response.statusCode} - ${response.reasonPhrase}";
    }
  } catch (e) {
    print("🚨 Network Error: $e");
    return "Network Error: Could not connect to the server. Please check your connection.";
  }
}
// Function to predict disease from an X-ray image
Future<List<String>> predictDiseaseFromImage(String imagePath) async {
  final String apiUrl = "$baseUrl/predict/xray";

  try {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['API-Key'] = apiKey;
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    print("📡 Sending X-ray for prediction: $imagePath");

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print("📡 Response Code: ${response.statusCode}");
    print("📡 Response Body: $responseBody");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(responseBody);

      if (data.containsKey("predicted_diseases")) {
        // Extract diseases with a value of 1 (positive findings)
        List<String> detectedDiseases = (data["predicted_diseases"] as Map<String, dynamic>)
            .entries
            .where((entry) => entry.value == 1)
            .map((entry) => entry.key)
            .toList();

        return detectedDiseases.isNotEmpty ? detectedDiseases : ["No abnormalities detected."];
      } else {
        return ["Error: Missing 'predicted_diseases' in response"];
      }
    } else {
      return ["Server Error: ${response.statusCode} - ${response.reasonPhrase}"];
    }
  } catch (e) {
    print("🚨 Error: $e");
    return ["Error: Unable to process the image."];
  }
}
