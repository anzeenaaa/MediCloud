import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import '../pages/../../functions/disease_prediction_service.dart';
import '../pages/../../functions/report_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicloud/features/user_auth/presentation/pages/profile_page.dart';
import 'package:medicloud/features/user_auth/presentation/pages/report_page.dart';

void main() {
  runApp(MyApp());
}

final Logger logger = Logger();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCloud Patient',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: Colors.blue.shade800,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      home: const PatHomePage(userName: 'User'),
    );
  }
}

class PatHomePage extends StatefulWidget {
  final String userName;
  const PatHomePage({super.key, required this.userName});

  @override
  _PatHomePageState createState() => _PatHomePageState();
}

class _PatHomePageState extends State<PatHomePage> {
  int _currentIndex = 0;
  TextEditingController _symptomController = TextEditingController();
  String _predictedDisease = "";
  String _imagePrediction = "";
  String? _selectedImagePath;
  String _generatedReport = "";

  void _onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(userName: widget.userName),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _selectedImagePath = result.files.single.path!;
        });
      }
    } catch (e) {
      logger.e('Error picking file: $e');
    }
  }

  Future<void> _predictDiseaseFromText() async {
    final String result = await predictDisease(_symptomController.text);
    setState(() {
      _predictedDisease = result;
    });
    _storePrediction(result);
    _generateReportIfReady();
  }

  Future<void> _predictDiseaseFromImage() async {
  if (_selectedImagePath == null) {
    setState(() {
      _imagePrediction = "No image selected.";
    });
    return;
  }

  try {
    logger.i("Sending image for prediction: $_selectedImagePath"); // ✅ Log file path

    List<String> predictedDiseases = await predictDiseaseFromImage(_selectedImagePath!);

    setState(() {
      if (predictedDiseases.isNotEmpty) {
        _imagePrediction = "Predicted Conditions:\n• " + predictedDiseases.join("\n• ");
      } else {
        _imagePrediction = "No disease detected.";
      }
    });

    _generateReportIfReady(); // ✅ Call report generation after prediction
  } catch (e, stacktrace) {
    logger.e("Error predicting from image: $e\n$stacktrace"); // ✅ Log error details
    setState(() {
      _imagePrediction = "Error: Unable to process image. Please try again.";
    });
  }
}
Future<void> _generateReportIfReady() async {
  if (_predictedDisease.isEmpty && _imagePrediction.isEmpty) {
    logger.w("No predictions available. Cannot generate report.");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No predictions available to generate a report.")),
    );
    return;
  }

  Map<String, int> detectedConditions = {};
  List<String> possibleDiseases = [
    "No Finding", "Enlarged Cardiomediastinum", "Cardiomegaly", "Lung Opacity",
    "Lung Lesion", "Edema", "Consolidation", "Pneumonia", "Atelectasis",
    "Pneumothorax", "Pleural Effusion", "Pleural Other", "Fracture", "Support Devices"
  ];

  for (var disease in possibleDiseases) {
    if (_imagePrediction.contains(disease)) {
      detectedConditions[disease] = 1;
    }
  }

  final Map<String, dynamic> xrayPrediction = {"predicted_diseases": detectedConditions};

  logger.i("Generating report for: Symptoms - $_predictedDisease, X-ray - ${xrayPrediction.toString()}");

  String? report = await ReportService.generateReport(_predictedDisease, xrayPrediction);

  if (report != null) {
    logger.i("Report successfully generated.");
    setState(() {
      _generatedReport = report;
    });

    // Navigate to the new report page and pass the generated report
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportPage(reportText: _generatedReport),
      ),
    );
  } else {
    logger.e("Report generation failed.");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Report generation failed. Please try again.")),
    );
  }
}


  Future<void> _storePrediction(String result) async {
    await FirebaseFirestore.instance.collection('patients').doc(widget.userName).set({
      'latestPrediction': result,
      'timestamp': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Health Checkup'),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildPredictionPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue.shade800,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Checkup'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildPredictionPage() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildSectionTitle('Describe Your Symptoms'),
            TextField(
              controller: _symptomController,
              decoration: InputDecoration(
                hintText: 'Enter symptoms...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 15),
            _buildActionButton('Predict from Symptoms', _predictDiseaseFromText),
            if (_predictedDisease.isNotEmpty)
              _buildPredictionCard('Predicted Disease:', _predictedDisease),
            const SizedBox(height: 20),
            _buildSectionTitle('Upload X-ray'),
            _buildActionButton('Upload Image', _pickFile),
            if (_selectedImagePath != null)
              Text(
                'Selected file: ${_selectedImagePath!.split('/').last}',
                style: const TextStyle(fontSize: 16),
              ),
            if (_selectedImagePath != null)
              _buildActionButton('Analyze and get Report', _predictDiseaseFromImage),
            if (_imagePrediction.isNotEmpty)
              _buildPredictionCard('X-ray Analysis:', _imagePrediction),

            // New Button for Generating Full Report
           // const SizedBox(height: 20),
            //buildActionButton('Generate Full Report', _generateReportIfReady),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Widget _buildPredictionCard(String title, String prediction) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            prediction,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
