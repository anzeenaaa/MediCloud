import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(MyApp());
}

final Logger logger = Logger(); // Initialize logger

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Homepage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatHomePage(),
    );
  }
}

class PatHomePage extends StatefulWidget {
  const PatHomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PatHomePage> {
  // ignore: unused_field
  int _currentIndex = 0;
  TextEditingController _symptomController = TextEditingController();

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png'],
      );
      if (result != null) {
        logger.i('File selected: ${result.files.single.name}');
      } else {
        logger.w('File selection canceled.');
      }
    } catch (e) {
      logger.e('Error picking file: $e');
    }
  }

  void _addSymptom(String symptom) {
    setState(() {
      if (!_symptomController.text.contains(symptom)) {
        _symptomController.text += '$symptom, ';
      }
    });
    logger.d('Added symptom: $symptom');
  }

  Widget _buildCard({
    required String title,
    required String description,
    required String backgroundImage,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: const Text('Explore'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      color: const Color.fromARGB(255, 250, 250, 251),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'johndoe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Phone: +1 234 567 8901',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => logger.i('Edit Profile button pressed'),
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEDICLOUD'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color.fromARGB(255, 250, 250, 251),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/avatar.jpg'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Active now',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              onPageChanged: _onPageChanged,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCard(
                        title: 'Health Insights',
                        description: 'Get AI-powered insights about your health.',
                        backgroundImage: 'assets/insight.jpg',
                        onPressed: () => logger.i('Health Insights pressed'),
                      ),
                      _buildCard(
                        title: 'Recent Records',
                        description: 'View your most recent health records.',
                        backgroundImage: 'assets/recent.jpg',
                        onPressed: () => logger.i('Recent Records pressed'),
                      ),
                      _buildCard(
                        title: 'Diet Suggestions',
                        description: 'Receive personalized diet recommendations.',
                        backgroundImage: 'assets/diet.jpg',
                        onPressed: () => logger.i('Diet Suggestions pressed'),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Logbook',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text('Enter Your Symptoms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _symptomController,
                        decoration: InputDecoration(
                          hintText: 'Describe your symptoms...',
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      const Text('Common Symptoms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(onPressed: () => _addSymptom('Cough'), child: const Text('Cough')),
                          ElevatedButton(onPressed: () => _addSymptom('Cold'), child: const Text('Cold')),
                          ElevatedButton(onPressed: () => _addSymptom('Headache'), child: const Text('Headache')),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Upload Medical Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Choose File'),
                      ),
                    ],
                  ),
                ),
                _buildProfileSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
